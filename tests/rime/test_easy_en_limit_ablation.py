"""Remove each limit change to check its effect. Live Rime data is forbidden."""
import json
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

source = Path("Rime/lua/easy_en.lua").read_text()
new_lookup = "env.mem:dict_lookup(header, true, glob and 0 or env.expand_word_count)"
old_lookup = "env.mem:dict_lookup(header, true, env.expand_word_count)"
cap = "                match_count = match_count + 1\n                if glob and match_count >= env.expand_word_count then break end\n"
assert new_lookup in source and cap in source
variants = {
    "baseline": source.replace(new_lookup, old_lookup).replace(cap, ""),
    "no_scan_limit_only": source.replace(cap, ""),
    "matching_cap_only": source.replace(new_lookup, old_lookup),
    "both_changes": source,
}
rows = []
scratch = Path.home() / ".hermes/cache/scratch"
scratch.mkdir(parents=True, exist_ok=True)
with tempfile.TemporaryDirectory(prefix="rime-limit-ablation-", dir=scratch) as folder:
    for name, code in variants.items():
        Path(folder, "easy_en.lua").write_text(code)
        env = dict(os.environ, RIME_TEST_LUA_DIR=folder, RIME_LIMIT_ABLATION="1")
        run = subprocess.run(["lua", "tests/rime/test_easy_en.lua"], env=env, text=True, capture_output=True, check=True)
        row = {"variant": name, **json.loads(run.stdout)}
        row["respects_matching_cap"] = row["matching_count"] <= 2
        rows.append(row)
assert [(r["finds_late_result"], r["matching_count"]) for r in rows] == [(False, 0), (True, 3), (False, 0), (True, 2)]

engine_rows = []
if len(sys.argv) == 3:
    console, data_dir = sys.argv[1:]
    root = Path(data_dir).resolve()
    lua_path = root / "lua/easy_en.lua"
    assert root.is_relative_to(scratch.resolve()) and not lua_path.is_symlink(), "Use an isolated copy under the Hermes scratch directory"
    saved = lua_path.read_text()
    try:
        for name, code in variants.items():
            lua_path.write_text(code)
            for schema in ("easy_en", "flypy_xhfast"):
                start = time.monotonic()
                run = subprocess.run([console, str(root), schema, "r*lt", "g*"], text=True, capture_output=True, check=True)
                elapsed = time.monotonic() - start
                queries = {r["query"]: r for r in map(json.loads, run.stdout.splitlines())}
                engine_rows.append({
                    "variant": name, "schema": schema,
                    "r*lt_finds_result": "result" in queries["r*lt"]["candidates"],
                    "g*_candidate_count": len(queries["g*"]["candidates"]),
                    "process_seconds": round(elapsed, 3),
                })
    finally:
        lua_path.write_text(saved)
    for row in engine_rows:
        expected = row["variant"] in ("no_scan_limit_only", "both_changes")
        assert row["r*lt_finds_result"] == expected, row
report = {"fixture": rows, "real_engine": engine_rows}
output = scratch / "rime-limit-ablation-results.json"
output.write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report, indent=2))
print("PASS limit ablation checks. Report:", output)
