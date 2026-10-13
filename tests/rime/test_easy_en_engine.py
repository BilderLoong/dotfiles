"""Check real keyboard input with a Rime C API console and isolated data."""
import json
import re
import subprocess
import sys
from pathlib import Path

console, data_dir = sys.argv[1:3]
queries = ["g*", "g**", "g?", "g?*", "g*l*", "g*l*b", "g*b", "g**b", "gl*b*", "glo?", "glo??", "g?o*", "glob*"]
results = []
for schema in ("easy_en", "flypy_xhfast"):
    run = subprocess.run([console, data_dir, schema, *queries], text=True, capture_output=True, check=True)
    rows = [json.loads(line) for line in run.stdout.splitlines()]
    assert len(rows) == len(queries), (schema, "missing query results")
    by_query = {row["query"]: row for row in rows}
    for row in rows:
        assert row["handled"] and row["input"] == row["query"], (schema, row)
    words = lambda query: {word.lower() for word in by_query[query]["candidates"]}
    assert words("g**b") == words("g*b"), (schema, "adjacent stars differ")
    assert {"glob", "globe"}.issubset(words("gl*b*")), (schema, "separated stars")
    assert "glob" in words("glo?"), (schema, "one-character wildcard")
    assert not {"glo", "globe"} & words("glo?"), (schema, "question mark width")
    assert words("glo??"), (schema, "two question marks returned no results")
    assert all(re.fullmatch(r"glo..", word) for word in words("glo??")), (schema, "two-character width")
    assert not {"grab", "grub"} & words("g*l*b"), (schema, "interior literal ignored")
    assert {"glob", "globe"}.issubset(words("glob*")), (schema, "existing completion")
    results.extend({"schema": schema, "query": row["query"], "candidate_count": len(row["candidates"])} for row in rows)
Path(data_dir, "glob-keyboard-results.json").write_text(json.dumps(results, indent=2) + "\n")
print(f"PASS real Rime keyboard regression: {len(results)} query checks across two schemas")
