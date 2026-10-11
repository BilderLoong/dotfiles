#!/usr/bin/env python3
"""PreToolUse hook for the asd-ste100 skill. The pre-send gate.

The Stop gate has a structural cost: it runs after the reply is on the
reader's screen, so a block puts a second copy there. This gate has no such
cost. It runs BEFORE the tool call, so a deny reaches the model only. The
model corrects the text and makes the same call again, and the reader sees
one clean result. This makes commit messages and board text deterministic in
a way the reply itself can never be.

Gated text:

- Bash        the commit message, from -m arguments and the heredoc body
- Elliptic    title, description, and body fields on create and update calls

Everything fails open. A parse miss, a broken linter, or a short text lets
the call through. The deny fires only over the same ceiling the Stop gate
uses, so the two gates agree on what is bad enough to stop.

Canonical copy: the ep01 kit, asd-ste100/hooks/ste-pregate.py
"""
import json
import os
import re
import subprocess
import sys

def find_lint():
    """The linter ships next to this skill. Look there first, then at the
    installed path, so the plugin cache, a skills-CLI copy, and the
    settings-route install all resolve."""
    root = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    for path in (os.path.join(root, "scripts", "ste-lint.py"),
                 os.path.expanduser("~/.claude/skills/asd-ste100/scripts/ste-lint.py")):
        if os.path.exists(path):
            return path
    return None


LINT = find_lint()

BLOCK_AT = 4.0        # same ceiling as the Stop gate
SHAPE_BLOCK_AT = 4
MIN_WORDS = 30        # a short message scores as noise - let it through

TEXT_FIELDS = ("title", "description", "body", "content")


HEREDOC = re.compile(
    r"<<-?[ \t]*(['\"]?)([A-Za-z_][A-Za-z0-9_]*)\1[^\n]*\n(.*?)\n[ \t]*\2[ \t]*(?=\n|[);&|}]|$)",
    re.S)
# "git" at a command position, then at most four arguments, then "commit".
# A command position is the start of the command, or the point after a
# separator, a pipe, a brace group, a subshell, or a command substitution.
# The bounded chain still covers "git -c key=value commit". "commit-tree"
# is a different command and does not match.
GIT_COMMIT = re.compile(
    r"(?:^|[;&|{(\n]|\$\()[ \t]*(?:[A-Za-z_][A-Za-z0-9_]*=\S*[ \t]+)*"
    r"git[ \t]+(?:[^\s|;&]+[ \t]+){0,4}commit(?![\w-])")


def mask(command, heredocs):
    """Blank out heredoc bodies and quoted text, and keep every offset.

    A heredoc body or a quoted string is data, not shell syntax. Version 1
    searched the raw command, so "git commit" inside a prompt, a JSON file, or
    a script written by the same command turned the call into a commit, and
    every heredoc body in it was scored as the message.
    """
    chars = list(command)
    for m in heredocs:
        for i in range(m.start(3), m.end(3)):
            chars[i] = " "
    out = []
    quote = None
    i = 0
    while i < len(chars):
        ch = chars[i]
        if quote is None and ch in "'\"":
            quote = ch
            out.append(ch)
        elif quote is not None and ch == "\\" and quote == '"' and i + 1 < len(chars):
            out.append("  ")
            i += 1
        elif quote is not None and ch == quote:
            quote = None
            out.append(ch)
        elif quote is not None:
            out.append(" ")
        else:
            out.append(ch)
        i += 1
    return "".join(out)


def commit_message(command):
    """The message text of a git commit command, or None.

    Covers -m arguments (single or double quoted) and a heredoc body that
    belongs to the commit command. An amend, fixup, or squash with no new
    message passes untouched. Text in other heredocs and in other commands
    is not a commit message and stays out.
    """
    heredocs = list(HEREDOC.finditer(command))
    masked = mask(command, heredocs)
    parts = []
    found = False
    for hit in GIT_COMMIT.finditer(masked):
        found = True
        start = hit.end()
        stop = re.search(r"[\n;&|}]", masked[start:])
        end = start + stop.start() if stop else len(masked)
        # A heredoc marker on the commit line owns the body below that line.
        line_heredocs = [m for m in heredocs if start <= m.start() < end]
        if line_heredocs:
            end = max(end, max(m.end() for m in line_heredocs))
        segment = command[start:end]
        if re.search(r"--(?:no-edit|fixup|squash)\b", masked[start:end]):
            continue
        parts.extend(m.group(3) for m in line_heredocs)
        seg_masked = mask(segment, list(HEREDOC.finditer(segment)))
        for m in re.finditer(r"(?:-m|--message)(?:\s+|=)(['\"])", seg_masked):
            quote = m.group(1)
            close = seg_masked.find(quote, m.end())
            if close < 0:
                continue
            value = segment[m.end():close]
            if not value.lstrip().startswith("$("):
                parts.append(value)
    if not found:
        return None
    text = "\n\n".join(p for p in parts if p.strip())
    return text or None


def elliptic_text(tool_input):
    parts = [v for k, v in (tool_input or {}).items()
             if k in TEXT_FIELDS and isinstance(v, str) and v.strip()]
    return "\n\n".join(parts) or None


def strip_noise(text):
    text = re.sub(r"^\s*\|.*\|\s*$", " ", text, flags=re.M)
    text = re.sub(r"https?://\S+", " ", text)
    return text


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0
    if not LINT:
        return 0
    tool = payload.get("tool_name") or ""
    tool_input = payload.get("tool_input") or {}

    if tool == "Bash":
        text = commit_message(tool_input.get("command") or "")
        what = "commit message"
        retry = "run the same command again with the corrected message"
    elif tool.startswith("mcp__elliptic__"):
        text = elliptic_text(tool_input)
        what = "task text"
        retry = "make the same call again with the corrected text"
    else:
        return 0
    if not text:
        return 0

    prose = strip_noise(text)
    if len(prose.split()) < MIN_WORDS:
        return 0
    try:
        proc = subprocess.run([sys.executable, LINT], input=prose,
                              capture_output=True, text=True, timeout=15)
        report = json.loads(proc.stdout)
    except Exception:
        return 0                      # never block on a broken linter

    score = report.get("total_per100w", 0)
    shape_total = report.get("shape_total", 0)
    if score <= BLOCK_AT and shape_total <= SHAPE_BLOCK_AT:
        return 0

    hits = {k: v for k, v in (report.get("violations") or {}).items() if v}
    shape = {k: v for k, v in (report.get("shape") or {}).items() if v}
    longs = report.get("sample_long_sentence") or []
    reason = (
        "ASD-STE100 pre-send gate. The {} scored {:.2f} violations per 100 "
        "words. The ceiling is {}. Counts: {}. Shape counts: {}.{} "
        "Nothing was sent - this gate runs before the call. Rewrite the text "
        "in STE. Fix the listed categories. Keep every fact and every "
        "identifier. Then {}."
    ).format(what, score, BLOCK_AT, hits, shape,
             " Longest: {}.".format(" | ".join(longs)) if longs else "",
             retry)
    print(json.dumps({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason,
    }}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
