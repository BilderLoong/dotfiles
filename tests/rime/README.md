# Rime easy_en regression tests

Run these commands from the repository root:

```sh
python3 tests/rime/test_easy_en_schema.py
/opt/homebrew/bin/lua tests/rime/test_easy_en.lua
```

The Python test checks both schema recognizer expressions with Python `re`. The Lua test loads the real `Rime/lua/easy_en.lua` translator and mocks the Rime globals that are not available in a standalone Lua process (`Memory`, `Phrase`, `yield`, and the composition context). It does not deploy schemas or replace parent-run real-engine keyboard tests.
