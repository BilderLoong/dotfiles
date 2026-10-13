import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def recognizer_pattern(path):
    content = path.read_text(encoding="utf-8")
    match = re.search(r"^\s*easy_en:\s*\"([^\"]*)\"", content, re.MULTILINE)
    if not match:
        raise AssertionError(f"easy_en recognizer pattern not found in {path}")
    return re.compile(match.group(1))


class EasyEnSchemaRecognizerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.easy_en = recognizer_pattern(ROOT / "Rime/easy_en.schema.yaml")
        cls.flypy = recognizer_pattern(ROOT / "Rime/flypy_xhfast.schema.yaml")

    def test_easy_en_recognizes_multiple_stars(self):
        self.assertRegex("g*l*b", self.easy_en)
        self.assertRegex("g**b", self.easy_en)

    def test_flypy_recognizes_multiple_stars(self):
        self.assertRegex("g*l*b", self.flypy)
        self.assertRegex("g**b", self.flypy)

    def test_easy_en_recognizes_partial_wildcard_inputs(self):
        for query in ("g*", "g**", "g*l*"):
            with self.subTest(query=query):
                self.assertRegex(query, self.easy_en)

    def test_flypy_recognizes_partial_wildcard_inputs(self):
        for query in ("g*", "g**", "g*l*"):
            with self.subTest(query=query):
                self.assertRegex(query, self.flypy)

    def test_easy_en_recognizes_question_wildcards_and_partial_inputs(self):
        for query in ("glo?", "g?o*", "g?", "g?*"):
            with self.subTest(query=query):
                self.assertRegex(query, self.easy_en)

    def test_flypy_recognizes_question_wildcards_and_partial_inputs(self):
        for query in ("glo?", "g?o*", "g?", "g?*"):
            with self.subTest(query=query):
                self.assertRegex(query, self.flypy)

    def test_existing_english_prefix_and_punctuation_rules_remain(self):
        self.assertRegex("ab-_\'*cd", self.easy_en)
        self.assertRegex("ab-_\'*cd", self.flypy)
        self.assertRegex("glob", self.easy_en)
        self.assertNotRegex("glob", self.flypy)
        self.assertNotRegex("*glob", self.easy_en)
        self.assertNotRegex("*glob", self.flypy)
        self.assertNotRegex("ab*cd-ef", self.easy_en)
        self.assertNotRegex("ab*cd-ef", self.flypy)


if __name__ == "__main__":
    unittest.main()
