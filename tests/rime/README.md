# Rime easy_en regression tests

Run these commands from the repository root:

```sh
python3 tests/rime/test_easy_en_schema.py
/opt/homebrew/bin/lua tests/rime/test_easy_en.lua
```

The Python test checks both schema recognizer expressions with Python `re`. The Lua test loads the real translator and supplies the Rime objects that a standalone Lua process cannot load. Its dictionary fixture uses real Rime comment values: an empty comment for an exact code, or `~` followed by the completion suffix.

## Real engine checks

`rime_api_console.cc` needs the official `rime_api.h` header for the installed librime version. For Squirrel 1.1.2, the linked engine version is 1.16.0.

Compile the console with the Squirrel libraries:

```sh
clang++ -std=c++17 -I "$RIME_HEADER_DIR" tests/rime/rime_api_console.cc \
  '/Library/Input Methods/Squirrel.app/Contents/Frameworks/librime.1.dylib' \
  -Wl,-rpath,'/Library/Input Methods/Squirrel.app/Contents/Frameworks' \
  -Wl,-rpath,'/Library/Input Methods/Squirrel.app/Contents/Frameworks/rime-plugins' \
  -o "$CONSOLE"
python3 tests/rime/test_easy_en_engine.py "$CONSOLE" "$ISOLATED_RIME_DIR"
```

Use a separate user-data directory with copies of the deployed schemas and dictionaries. Do not use the live directory while Squirrel runs. The engine test sends individual key events. It checks partial input, separated stars, consecutive stars, question marks, and existing completion. It saves query counts in `glob-keyboard-results.json` inside the isolated directory.

The existing lookup limits remain 300 in the Chinese schema and 666 in Easy English. A short prefix can miss a matching word beyond that limit. For example, `g*l*b` can miss `glob` in the Chinese schema, but `gl*b*` includes it.
