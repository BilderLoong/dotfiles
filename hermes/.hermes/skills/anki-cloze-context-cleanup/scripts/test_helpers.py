"""Run offline: python3 -B -m unittest discover -s scripts -p 'test_*.py'."""
import json
import os
import tempfile
import unittest
from datetime import datetime, timezone
from pathlib import Path

import backup_gc as gc
import filter_candidates as filtering


def settings(mode="custom"):
    return {"options": {"profiles": [
        {"options": {"general": {"language": code.lower()}, "sentenceParsing": {
            "terminationCharacterMode": mode if code == "EN" else "custom",
            "terminationCharacters": [
                {"enabled": True, "character1": ".", "character2": None},
                {"enabled": True, "character1": "。", "character2": None},
                {"enabled": False, "character1": "…", "character2": None},
                {"enabled": True, "character1": "«", "character2": "»"},
            ],
        }}} for code in ("FR", "EN", "DE", "JA", "ZH", "LA")
    ]}}


def note(length, punctuation=False, language="FR", note_id=1):
    return {"noteId": note_id, "modelName": "Yomichan", "tags": [language],
            "fields": {name: {"value": value} for name, value in zip(
                filtering.FIELDS, ("", "x", "a" * (length - 1 - punctuation) + ("." if punctuation else ""))
            )}}


class CandidateTests(unittest.TestCase):
    def setUp(self):
        self.rules = filtering.parse_settings(settings("custom-no-newlines"))
        self.assertIsInstance(self.rules, dict)

    def test_strict_cutoffs_and_languages(self):
        self.assertEqual(set(filtering.CUTOFFS), {"FR", "EN", "JA"})
        for code in ("FR", "EN"):
            for length, punctuated, wanted in [(150, False, False), (151, False, True), (300, True, False), (301, True, True)]:
                with self.subTest(code=code, length=length, punctuated=punctuated):
                    self.assertEqual(filtering.inspect_note(note(length, punctuated, code), self.rules)["status"], "candidate" if wanted else "skipped")
        for length, punctuated, wanted in [(100, False, False), (101, False, True), (1000, True, False)]:
            self.assertEqual(filtering.inspect_note(note(length, punctuated, "JA"), self.rules)["status"], "candidate" if wanted else "skipped")
        for code in ("DE", "ZH", "LA"):
            self.assertEqual(filtering.inspect_note(note(1000, False, code), self.rules)["reason"], "excluded_language")

    def test_colon_is_not_added_to_settings(self):
        text = "Ainsi, quand il aperçut pour la première fois mon avion (je ne dessinerai pas mon avion, c’est un dessin beaucoup trop compliqué pour moi) il me demanda :"
        n = note(154)
        n["fields"]["cloze-body"]["value"] = text
        n["fields"]["cloze-suffix"]["value"] = ""
        result = filtering.inspect_note(n, self.rules)
        self.assertEqual((result["length"], result["hasPunctuation"], result["status"]), (154, False, "candidate"))

    def test_visible_text_and_newline_modes(self):
        self.assertEqual(filtering.visible_text('<div>A&nbsp;<ruby>漢<rt>かん.</rt><rp>(.)</rp></ruby></div><div>B</div>[sound:x.mp3]'), 'A 漢\nB')
        self.assertEqual(filtering.visible_text('<span title=".">a</span><script>bad.</script><br>b'), 'a\nb')
        self.assertEqual(filtering.visible_text('<div>A</div>'), 'A')
        for code, has_punctuation in [("FR", True), ("EN", False)]:
            n = note(320, language=code)
            n["fields"]["cloze-prefix"]["value"] = "a<br>b"
            result = filtering.inspect_note(n, self.rules)
            self.assertEqual(result["hasPunctuation"], has_punctuation)
            self.assertEqual(result["fields"], {key: value["value"] for key, value in n["fields"].items()})

    def test_paired_quotes_commas_and_disabled_ellipsis(self):
        n = note(160)
        n["fields"]["cloze-prefix"]["value"] = "«a», l'été…"
        self.assertFalse(filtering.inspect_note(n, self.rules)["hasPunctuation"])

    def test_invalid_notes_and_conflicting_profiles(self):
        n = note(160)
        n["tags"] = ["FR", "EN"]
        self.assertEqual(filtering.inspect_note(n, self.rules)["reason"], "ambiguous_language")
        n["tags"] = ["FR", "DE"]
        self.assertEqual(filtering.inspect_note(n, self.rules)["reason"], "ambiguous_language")
        n["tags"] = ["FR", "fr"]
        self.assertEqual(filtering.inspect_note(n, self.rules)["status"], "candidate")
        n["fields"]["cloze-body"]["value"] = "<br>"
        self.assertEqual(filtering.inspect_note(n, self.rules)["reason"], "empty_body")
        del n["fields"]["cloze-body"]
        self.assertEqual(filtering.inspect_note(n, self.rules)["reason"], "invalid_fields")
        value = settings()
        alternate = settings()["options"]["profiles"][0]
        alternate["options"]["sentenceParsing"]["terminationCharacterMode"] = "custom-no-newlines"
        value["options"]["profiles"].append(alternate)
        self.assertIsInstance(filtering.parse_settings(value), str)
        self.assertIsInstance(filtering.parse_settings(42), str)

    def test_only_supported_language_settings_are_required(self):
        value = settings()
        profiles = [profile for profile in value["options"]["profiles"]
                    if profile["options"]["general"]["language"] in {"fr", "en", "ja"}]
        self.assertIsInstance(filtering.parse_settings({"options": {"profiles": profiles}}), dict)

    def test_read_actions_profile_and_id_guards(self):
        calls = []
        def call(action, params):
            calls.append(action)
            return {"getActiveProfile": "ME", "findNotes": [1], "notesInfo": [note(151)]}[action]
        self.assertEqual(len(filtering.read_notes(call, "ME", "added:2 note:Yomichan", None)), 1)
        self.assertEqual(set(calls), {"getActiveProfile", "findNotes", "notesInfo"})
        with self.assertRaises(ValueError):
            filtering.read_notes(lambda action, params: "Other", "ME", "query", None)
        with self.assertRaises(ValueError):
            filtering.read_notes(lambda action, params: "ME" if action == "getActiveProfile" else [note(151, note_id=2)], "ME", None, [1])


class BackupTests(unittest.TestCase):
    def test_calendar_month_and_boundary(self):
        self.assertEqual(gc.expires_at(datetime(2024, 1, 31, tzinfo=timezone.utc)), datetime(2024, 2, 29, tzinfo=timezone.utc))
        self.assertEqual(gc.expires_at(datetime(2025, 1, 31, tzinfo=timezone.utc)), datetime(2025, 2, 28, tzinfo=timezone.utc))
        self.assertEqual(gc.expires_at(datetime(2025, 12, 31, tzinfo=timezone.utc)), datetime(2026, 1, 31, tzinfo=timezone.utc))

    def test_gc_dry_run_delete_and_unknown_files(self):
        with tempfile.TemporaryDirectory() as tmp:
            folder = Path(tmp)
            expired = folder / 'backup-20250131T000000Z.json'
            expired.write_text(json.dumps({"kind": gc.KIND, "createdAt": "2025-01-31T00:00:00Z", "expiresAt": "2025-02-28T00:00:00Z"}))
            fresh = folder / 'backup-20250228T000000Z.json'
            fresh.write_text(json.dumps({"kind": gc.KIND, "createdAt": "2025-02-28T00:00:00Z", "expiresAt": "2025-03-28T00:00:00Z"}))
            invalid = folder / 'backup-broken.json'
            invalid.write_text('{bad')
            unrelated = folder / 'notes.json'
            unrelated.write_text('{}')
            link = folder / 'backup-link.json'
            link.symlink_to(expired)
            nested = folder / 'nested'
            nested.mkdir()
            (nested / expired.name).write_text(expired.read_text())
            now = datetime(2025, 2, 28, tzinfo=timezone.utc)
            preview = gc.collect(folder, now, delete=False)
            self.assertEqual(len(preview['expired']), 1)
            self.assertTrue(expired.exists())
            result = gc.collect(folder, now, delete=True)
            self.assertEqual(len(result['deleted']), 1)
            self.assertFalse(expired.exists())
            self.assertTrue(fresh.exists() and invalid.exists() and unrelated.exists() and link.is_symlink())
            self.assertTrue((nested / expired.name).exists())
            self.assertEqual(gc.collect(folder, now, delete=True)['deleted'], [])

    def test_expiry_metadata_and_missing_directory(self):
        self.assertIsInstance(gc.backup_expiry({"kind": gc.KIND, "createdAt": "2025-01-01T00:00:00", "expiresAt": "2025-02-01T00:00:00Z"}), str)
        self.assertIsInstance(gc.backup_expiry({"kind": gc.KIND, "createdAt": "2025-01-01T00:00:00Z", "expiresAt": "2025-01-02T00:00:00Z"}), str)
        with tempfile.TemporaryDirectory() as tmp:
            self.assertEqual(gc.collect(Path(tmp)/'missing', datetime.now(timezone.utc), False)['deleted'], [])

    def test_malformed_and_nonregular_backups_are_retained(self):
        with tempfile.TemporaryDirectory() as tmp:
            folder = Path(tmp)
            invalid = folder/'backup-20250101T000000Z.json'
            invalid.write_text('{bad json')
            fifo = folder/'backup-20250102T000000Z.json'
            os.mkfifo(fifo)
            result = gc.collect(folder, datetime(2026, 1, 1, tzinfo=timezone.utc), True)
            self.assertEqual(result['deleted'], [])
            self.assertTrue(invalid.exists() and fifo.exists())
            self.assertEqual(len(result['errors']), 1)
            self.assertEqual(len(result['skipped']), 1)


if __name__ == '__main__':
    unittest.main()
