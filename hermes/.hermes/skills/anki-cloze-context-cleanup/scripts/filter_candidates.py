#!/usr/bin/env python3
"""Read-only Anki candidate selection; Python standard library only."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import urllib.request
from collections import Counter
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path
from typing import Any, Callable

FIELDS = ("cloze-prefix", "cloze-body", "cloze-suffix")
CUTOFFS = {"FR": {"without": 150, "with": 300}, "EN": {"without": 150, "with": 300},
           "JA": {"without": 100, "with": None}}
READ_ACTIONS = {"getActiveProfile", "findNotes", "notesInfo"}


class VisibleText(HTMLParser):
    """HTMLParser callbacks require private state; no source content is executed."""
    blocks = {"div", "p", "li", "tr", "blockquote", "section", "article", "ul", "ol", "table", "pre", "hr"}
    ignored = {"rt", "rp", "script", "style", "template"}

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.parts: list[str] = []
        self.hidden: list[str] = []
        self.pending_break = False

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag in self.ignored:
            self.hidden.append(tag)
        elif not self.hidden:
            if tag == "br":
                self.parts.append("\n")
                self.pending_break = False
            elif tag in self.blocks:
                self.pending_break = bool(self.parts)

    def handle_endtag(self, tag: str) -> None:
        if self.hidden:
            if tag == self.hidden[-1]:
                self.hidden.pop()
        elif tag in self.blocks:
            self.pending_break = bool(self.parts)

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        self.handle_starttag(tag, attrs)
        self.handle_endtag(tag)

    def handle_data(self, data: str) -> None:
        if self.hidden or not data:
            return
        if self.pending_break and self.parts and not self.parts[-1].endswith("\n") and not data.startswith("\n"):
            self.parts.append("\n")
        self.parts.append(data)
        self.pending_break = False


def visible_text(value: str) -> str:
    parser = VisibleText()
    parser.feed(re.sub(r"\[sound:[^\]]*\]", "", value, flags=re.IGNORECASE))
    parser.close()
    return "".join(parser.parts)


def parse_profile(profile: object) -> tuple[str, dict[str, Any]] | str:
    if not isinstance(profile, dict) or not isinstance(profile.get("options"), dict):
        return "Invalid Yomitan profile options"
    options = profile["options"]
    general, parsing = options.get("general"), options.get("sentenceParsing")
    if not isinstance(general, dict) or not isinstance(general.get("language"), str) or not isinstance(parsing, dict):
        return "Each Yomitan profile needs language and sentenceParsing settings"
    mode, entries = parsing.get("terminationCharacterMode"), parsing.get("terminationCharacters")
    if mode not in {"custom", "custom-no-newlines"} or not isinstance(entries, list):
        return "Only custom and custom-no-newlines sentence parsing modes are supported"
    if any(not isinstance(e, dict) or type(e.get("enabled")) is not bool or not isinstance(e.get("character1"), str)
           or not e["character1"] or (e.get("character2") is not None and not isinstance(e["character2"], str)) for e in entries):
        return "Invalid Yomitan termination character entry"
    marks = sorted({e["character1"] for e in entries if e["enabled"] and e.get("character2") is None})
    return general["language"].upper(), {"marks": marks, "newlines": mode == "custom"}


def parse_settings(document: object) -> dict[str, dict[str, Any]] | str:
    if not isinstance(document, dict) or not isinstance(document.get("options"), dict):
        return "Expected a Yomitan settings export with options.profiles"
    profiles = document["options"].get("profiles")
    if not isinstance(profiles, list) or not profiles:
        return "Yomitan settings have no profiles"
    parsed = [parse_profile(profile) for profile in profiles]
    errors = [value for value in parsed if isinstance(value, str)]
    if errors:
        return errors[0]
    entries = [value for value in parsed if isinstance(value, tuple)]
    codes = {code for code, _ in entries}
    if not set(CUTOFFS).issubset(codes):
        return "Missing settings for: " + ", ".join(sorted(set(CUTOFFS) - codes))
    if any(len({json.dumps(rule, sort_keys=True) for key, rule in entries if key == code}) > 1 for code in codes):
        return "Conflicting punctuation profiles for the same language; supply an unambiguous settings export"
    return dict(entries)


def inspect_note(note: dict[str, Any], rules: dict[str, dict[str, Any]]) -> dict[str, Any]:
    base = {"noteId": note["noteId"], "status": "skipped"}
    if note.get("modelName") != "Yomichan":
        return {**base, "reason": "other_note_type"}
    tags = note.get("tags")
    if not isinstance(tags, list) or not all(isinstance(tag, str) for tag in tags):
        return {**base, "reason": "invalid_tags"}
    codes = sorted({tag.upper() for tag in tags if tag.upper() in rules})
    if len(codes) != 1:
        return {**base, "reason": "ambiguous_language" if codes else "missing_language"}
    code = codes[0]
    base = {**base, "language": code}
    if code not in CUTOFFS:
        return {**base, "reason": "excluded_language"}
    fields = note.get("fields")
    if not isinstance(fields, dict) or any(not isinstance(fields.get(key), dict) or not isinstance(fields[key].get("value"), str) for key in FIELDS):
        return {**base, "reason": "invalid_fields"}
    raw = {key: fields[key]["value"] for key in FIELDS}
    visible = {key: visible_text(raw[key]) for key in FIELDS}
    if not visible["cloze-body"].strip():
        return {**base, "reason": "empty_body"}
    text = "".join(visible.values())
    if visible_text("".join(raw.values())) != text:
        return {**base, "reason": "html_crosses_field_boundary"}
    marks = [mark for mark in rules[code]["marks"] if mark in text]
    newline = rules[code]["newlines"] and any(char in text for char in "\r\n")
    has_punctuation = bool(marks or newline)
    cutoff = CUTOFFS[code]["with" if has_punctuation else "without"]
    measured = {**base, "length": len(text), "hasPunctuation": has_punctuation, "cutoff": cutoff}
    if cutoff is None:
        return {**measured, "reason": "punctuation_excluded_for_language"}
    if len(text) <= cutoff:
        return {**measured, "reason": "at_or_below_cutoff"}
    return {**measured, "status": "candidate", "reason": "above_cutoff_with_punctuation" if has_punctuation else "above_cutoff_without_punctuation",
            "punctuationMarks": marks, "newlineBoundary": newline, "fields": raw, "visibleFields": visible}


def api_call(endpoint: str, action: str, params: dict[str, Any]) -> Any:
    if action not in READ_ACTIONS:
        raise ValueError("This script only permits read actions")
    request = urllib.request.Request(endpoint, json.dumps({"action": action, "version": 6, "params": params}).encode(), {"Content-Type": "application/json"})
    with urllib.request.urlopen(request, timeout=30) as response:
        value = json.load(response)
    if not isinstance(value, dict) or "error" not in value or "result" not in value or value["error"] is not None:
        raise ValueError(f"AnkiConnect {action} failed: {value.get('error') if isinstance(value, dict) else 'invalid response'}")
    return value["result"]


def read_notes(call: Callable[[str, dict[str, Any]], Any], profile: str, query: str | None, ids: list[int] | None) -> list[dict[str, Any]]:
    if call("getActiveProfile", {}) != profile:
        raise ValueError(f"Active Anki profile must be {profile!r}; no profile switch was attempted")
    selected = call("findNotes", {"query": query}) if query is not None else ids
    if not isinstance(selected, list) or not all(type(n) is int and n > 0 for n in selected) or len(set(selected)) != len(selected):
        raise ValueError("Selection contains invalid or duplicate note IDs")
    notes: list[dict[str, Any]] = []
    for start in range(0, len(selected), 200):
        batch = selected[start:start + 200]
        result = call("notesInfo", {"notes": batch})
        if not isinstance(result, list) or not all(isinstance(n, dict) and type(n.get("noteId")) is int for n in result):
            raise ValueError("notesInfo returned malformed notes")
        if len(result) != len(batch) or {n["noteId"] for n in result} != set(batch):
            raise ValueError("notesInfo IDs do not match the requested batch")
        notes.extend(result)
    if call("getActiveProfile", {}) != profile:
        raise ValueError("Anki profile changed during inspection; discard this read")
    return notes


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    selection = parser.add_mutually_exclusive_group(required=True)
    selection.add_argument("--query", help="Explicit Anki search, for example 'added:2 note:Yomichan'")
    selection.add_argument("--note-ids", nargs="+", type=int)
    parser.add_argument("--settings", required=True, type=Path, help="Yomitan settings export")
    parser.add_argument("--output", required=True, type=Path, help="New local JSON report; existing files are never overwritten")
    parser.add_argument("--profile", default="ME")
    parser.add_argument("--endpoint", default="http://127.0.0.1:8765")
    args = parser.parse_args()
    try:
        if args.query is not None and not args.query.strip():
            raise ValueError("An explicit nonempty query is required")
        if args.output.exists():
            raise ValueError(f"Output already exists: {args.output}")
        raw_settings = args.settings.read_bytes()
        rules = parse_settings(json.loads(raw_settings))
        if isinstance(rules, str):
            raise ValueError(rules)
        started = datetime.now(timezone.utc).isoformat()
        notes = read_notes(lambda action, params: api_call(args.endpoint, action, params), args.profile, args.query, args.note_ids)
        results = [inspect_note(note, rules) for note in notes]
        candidates = [result for result in results if result["status"] == "candidate"]
        skipped = [result for result in results if result["status"] != "candidate"]
        summary = {"selected": len(notes), "candidates": len(candidates), "byLanguage": {
            code: {"withPunctuation": sum(n["language"] == code and n["hasPunctuation"] for n in candidates),
                   "withoutPunctuation": sum(n["language"] == code and not n["hasPunctuation"] for n in candidates)} for code in CUTOFFS},
                   "skippedReasons": dict(Counter(n["reason"] for n in skipped))}
        report = {"kind": "anki-cloze-candidates/v1", "profile": args.profile, "query": args.query,
                  "noteIds": [n["noteId"] for n in notes], "startedAt": started, "capturedAt": datetime.now(timezone.utc).isoformat(),
                  "settings": {"path": str(args.settings.absolute()), "sha256": hashlib.sha256(raw_settings).hexdigest(), "rules": rules},
                  "cutoffs": CUTOFFS, "comparison": ">", "summary": summary, "candidates": candidates, "skipped": skipped}
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with args.output.open("x", encoding="utf-8") as output:
            json.dump(report, output, ensure_ascii=False, indent=2)
            output.write("\n")
        print(json.dumps({"output": str(args.output.absolute()), **summary}, ensure_ascii=False))
        return 0
    except (OSError, ValueError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
