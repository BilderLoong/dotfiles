import importlib.util
import json
import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
HOOK = ROOT / "hooks" / "ste-pregate.py"
SPEC = importlib.util.spec_from_file_location("ste_pregate", HOOK)
GATE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GATE)

SLOP = ("Great question! We have leveraged a robust, cutting-edge solution to seamlessly "
        "facilitate the deployment process; furthermore, the file is read by the parser "
        "prior to initialization; it is important to note that this is powerful.")


def run_hook(command):
    payload = {"tool_name": "Bash", "tool_input": {"command": command}}
    proc = subprocess.run([sys.executable, str(HOOK)], input=json.dumps(payload),
                          capture_output=True, text=True, timeout=30)
    return proc.stdout.strip()


class CommitDetectionTests(unittest.TestCase):
    def test_message_flag_is_gated(self):
        for command in (
            'git commit -m "Fix the bug"',
            "git commit -m 'Fix the bug'",
            'cd repo && git add . && git commit -m "Fix the bug"',
            'git -c user.name=a commit -m "Fix the bug"',
            'GIT_AUTHOR_NAME=a git commit --message="Fix the bug"',
        ):
            with self.subTest(command=command):
                self.assertEqual(GATE.commit_message(command), "Fix the bug")

    def test_commit_boundaries_stay_exact(self):
        cases = (
            ('git commit -m "One" & git commit -m "Two"', "One\n\nTwo"),
            ('git commit -m "One" && git commit -m "Two"', "One\n\nTwo"),
            ('{ git commit -m "Fix the bug"; }', "Fix the bug"),
            ("git commit -F - <<EOF\nFix the bug.\nEOF; echo done", "Fix the bug."),
            ('git commit -m "Fix the bug" 2>&1', "Fix the bug"),
        )
        for command, message in cases:
            with self.subTest(command=command):
                self.assertEqual(GATE.commit_message(command), message)

    def test_heredoc_of_the_commit_is_gated(self):
        command = 'git commit -m "$(cat <<\'EOF\'\nFix the bug.\n\nAdd a mutex.\nEOF\n)"'
        self.assertEqual(GATE.commit_message(command), "Fix the bug.\n\nAdd a mutex.")
        command = "git commit -F - <<EOF\nFix the bug.\nEOF"
        self.assertEqual(GATE.commit_message(command), "Fix the bug.")

    def test_commit_text_in_data_is_not_a_commit(self):
        for command in (
            "cat > prompts.json <<'EOF'\n{\"p\": \"Write a git commit message\"}\nEOF",
            'echo "then run git commit and push"',
            "python3 -c \"print('git commit -m x')\"",
            "grep -r 'git commit' docs/",
            'git commit-tree HEAD -m "Fix the bug"',
        ):
            with self.subTest(command=command):
                self.assertIsNone(GATE.commit_message(command))

    def test_other_heredocs_stay_out_of_the_message(self):
        command = ("cat > notes.md <<'EOF'\n" + SLOP + "\nEOF\n"
                   'git add notes.md && git commit -m "Add the notes"')
        self.assertEqual(GATE.commit_message(command), "Add the notes")

    def test_no_message_commits_pass(self):
        for command in ("git commit --amend --no-edit", "git commit --fixup HEAD~1"):
            with self.subTest(command=command):
                self.assertIsNone(GATE.commit_message(command))


class HookTests(unittest.TestCase):
    def test_slop_commit_is_denied(self):
        out = run_hook('git commit -m "' + SLOP + '"')
        self.assertIn('"deny"', out)

    def test_slop_in_a_written_file_is_not_denied(self):
        command = ("cat > prompts.json <<'EOF'\n{\"p4\": \"Write a git commit message.\"}\nEOF\n"
                   "cat > run.sh <<'EOF'\n" + SLOP + "\nEOF")
        self.assertEqual(run_hook(command), "")


if __name__ == "__main__":
    unittest.main()
