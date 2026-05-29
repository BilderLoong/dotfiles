# Zinit Config Guide

How to add plugins to `setup_zinit.sh` and how zinit works under the hood.

---

## Plugin Type Taxonomy

Every plugin falls into one of 7 types. Find your type, copy the pattern, put it in the right layer.

| Type | Description | Key ices | Layer |
|------|-------------|----------|-------|
| A | Completion from stdout | `as'completion'` `nocompile` `atclone` | L1 |
| B | Completion via side-effect | `eval"cmd install-completions"` | L1 |
| C | Pre-existing completion file | `as"completion"` | L1 |
| D | Binary + completion | `as"command" from"gh-r"` `atclone` | L2 |
| E | Shell plugin | none (just source `.zsh`) | L2 |
| F | Environment init | `as"null" eval"cmd init"` | L1 or L2 |
| G | OMZ lib/plugin | `OMZL::` / `OMZP::` prefix | L2 |

**Layer decision rule:**
- Generates `_*` completion files? → L1
- Sets env vars other plugins consume (e.g. PATH)? → L1
- Everything else → L2 (default)

### Type A — Completion from stdout

Tool outputs `#compdef TOOL` to stdout. **Examples:** ast-grep, poetry, opencode, uv.

```zsh
has'TOOL' id-as'TOOL-completions' as'completion' nocompile \
    atclone'TOOL completions zsh > _TOOL' \
    atpull'%atclone' run-atpull \
    zdharma-continuum/null
```

| Ice | Why |
|-----|-----|
| `as'completion'` | Tells zinit to discover and install `_*` files |
| `nocompile` | **Required.** Compilation at `!atclone` fails on empty `null` dir, bails before installing completions |
| `id-as` | Unique name for the null plugin |
| `has` | Skip if tool isn't installed |
| `atclone` | Generate the completion file after clone |
| `atpull'%atclone'` | Re-run on update |
| `run-atpull` | Force atpull even when `null` has no new commits |

**Wrong approaches:**

| # | Wrong | Why it fails |
|---|-------|--------------|
| 1 | `eval"tool completions zsh"` | `eval` sources stdout as script — defines the function in-shell but never installs into `$fpath` |
| 2 | Missing `nocompile` | Compilation at `!atclone` fails (empty dir → exit 1), subshell bails before completion installation |
| 3 | Missing `as'completion'` | `_*` file is generated but zinit doesn't know to install it |
| 4 | Missing `run-atpull` | `atpull` only fires on new commits; `null` rarely updates, so completions never regenerate |

### Type B — Completion via side-effect

Tool runs a command that installs completions as a side effect (outputs bash-style `complete -C`, not `#compdef`). **Example:** syncthing.

```zsh
has'TOOL' id-as'TOOL-completions' \
    eval"TOOL install-completions" \
    zdharma-continuum/null
```

No `nocompile` needed — there's no `atclone`, so no compilation step runs. The `eval` captures stdout and sources it as a script.

**Wrong approach:** `as'completion' atclone"syncthing install-completions > _syncthing"` — the output is bash-style `complete -C`, not a zsh `#compdef` file.

### Type C — Pre-existing completion file

Completion file already exists — no generation needed. **Examples:** claude completions from a repo, OMZ docker completions.

```zsh
# From a plugin repo that ships a _* file
has'claude' id-as'claude-completions' as'completion' \
    wbingli/zsh-claudecode-completion

# From Oh My Zsh
zinit ice as"completion"
zinit snippet OMZP::docker/_docker
```

The `as"completion"` ice tells zinit to install the file into `$ZINIT[COMPLETIONS_DIR]`. No `nocompile` or `atclone` needed.

### Type D — Binary + completion (Hybrid)

Installs a binary from GitHub releases AND generates completions as a side effect. **Example:** atuin.

```zsh
as"command" from"gh-r" \
    bpick"TOOL-*.tar.gz" mv"TOOL*/TOOL -> TOOL" \
    atclone"./TOOL init zsh > init.zsh; ./TOOL gen-completions --shell zsh > _TOOL" \
    atpull"%atclone" src"init.zsh" \
    for user/repo
```

**Why `as"command"` not `as'completion'`:** The primary purpose is the binary; completions are a side effect. zinit skips compilation when `as=command`, so `nocompile` isn't needed.

→ L2: the binary is the main thing. L1 is for plugins whose PRIMARY purpose is completions.

### Type E — Shell plugin

Standard zsh plugin — just a `.zsh` file to source. No special ices. **Examples:** fast-syntax-highlighting, fzf-tab, zsh-autosuggestions.

```zsh
# Just add to a for block — nothing else needed
user/plugin-name
```

→ L2 (default). Exception: `zsh-vi-mode` goes in L1 so keybindings load early.

### Type F — Environment init

Runs an init command but has no plugin files to source. **Examples:** pyenv, fnm, starship, zoxide, thefuck, navi.

```zsh
id-as'NAME_init' as"null" has'CMD' eval"CMD init zsh" \
    zdharma-continuum/null
```

**Layer rule:**
- → L1 if it sets env vars other plugins consume (pyenv: sets `$PATH`)
- → L2 if it only affects the interactive shell (starship, thefuck, navi, fnm, zoxide)

`as"null"` tells zinit there are no files to source — only the `eval` matters.

### Type G — OMZ lib/plugin

Pre-built Oh My Zsh library or plugin.

```zsh
# Library
has'git' OMZL::git.zsh

# Plugin
has'git' OMZP::git
```

→ L2: zsh utility libraries. They don't generate completions at load time.

---

### Why `nocompile` is required (Type A)

zinit's install order:

```
1. Clone plugin
2. !atclone hooks  ← compilation runs HERE
3. atclone         ← your command creates _TOOL
4. completion installation  ← zinit discovers _TOOL
```

Compilation (step 2) happens **before** `atclone` (step 3) creates your completion file. On an empty `zdharma-continuum/null` directory:

- Without `nocompile`: compilation finds nothing → exit 1 → subshell bails → step 4 never reached → `_TOOL` never installed
- With `nocompile`: compilation skips → exit 0 → `atclone` runs → step 4 discovers `_TOOL` → installed

**When `nocompile` is NOT needed:**
- Type B: no `atclone`, so no compilation step
- Type C: no `atclone`, completion file already exists
- Type D: `as"command"` skips compilation automatically
- Types E, F, G: no completions being generated

---

## How Zinit Works

### Scheduler & wait ordering

`@zinit-scheduler` is a `precmd` hook (`zinit.zsh:3268`). Each `wait` plugin creates a task with a timestamp:

```
timestamp = EPOCHSECONDS + wait_seconds + priority_suffix
```

| Suffix | Priority | Example | Timestamp |
|--------|----------|---------|-----------|
| `a` | 1 (highest) | `wait"0a"` | EPOCH + 1 |
| `b` | 2 | `wait"0b"` | EPOCH + 2 |
| `c` | 3 (lowest) | `wait"0c"` | EPOCH + 3 |
| _(none)_ | 1 (default) | `wait"0"` | EPOCH + 1 |

**Ordering rules:**
- Same timestamp → declaration order in `.zshrc` (WAIT_IDX)
- Different timestamps → lower timestamp runs first

All turbo tasks run on the first `precmd`, **before the prompt becomes interactive**. The user can't type until every task finishes. This means within-priority ordering is a non-issue for correctness — it only matters for startup feel (e.g. starship's `wait'!0'` to redraw the prompt early).

**`wait'!0'`:** The `!` prefix strips the delay and triggers immediate `zle .reset-prompt` after load. Used by starship so the prompt redraws on first display.

### Sequential execution

The scheduler processes plugins one at a time (`zinit.zsh:2570`) with a 0.0002s yield between them. There are no race conditions.

### Why explicit `zicompinit; zicdreplay` is needed

Zinit's automatic `compinit` only fires during first-time clone (when `.zinit-setup-plugin-dir` creates the plugin directory). On subsequent shell starts, the directories already exist and the setup is skipped — **no automatic `compinit`**.

Two things must happen for completions to work:

| Step | What | Handles |
|------|------|---------|
| `zicompinit` | Runs `compinit`, scans `$fpath` for `_*` files | File-based completions (Types A, C) |
| `zicdreplay` | Replays `compdef` calls captured during plugin loading | Runtime `compdef` from scripts like `zoxide init zsh`, `atuin init zsh` |

If a plugin calls `compdef` (via `eval"tool init zsh"`) and `zicdreplay` never runs, that completion is silently dropped.

The config places `zicompinit; zicdreplay` as the **last entry in L2**, after all plugins. It's in its own `for` block at `wait"0b"`, so declaration order makes it the last L2 task. Since everything runs before the prompt is interactive, this guarantees completions are ready when the user starts typing.

### compdef hijacking

During plugin load, zinit temporarily replaces `compdef` with `:zinit-tmp-subst-compdef` (`zinit.zsh:743-754`). Any `compdef` call is captured to `ZINIT_COMPDEF_REPLAY` instead of executing. Later, `zicdreplay` (which calls `.zinit-compdef-replay` at `zinit.zsh:1890`) replays all captured calls.

`.zinit-compinit` (`zinit-install.zsh:617`) is called automatically only during first-time clone or manual operations like `zinit update`. It runs `compinit` but does **not** replay `compdef` calls — you still need `zicdreplay`.

### Autosuggestions

`_zsh_autosuggest_start` only binds zle widgets (`start.zsh:7-19`). Suggestions are fetched **lazily** at type time via strategies that query completion state dynamically (`fetch.zsh:9-27`). There is no snapshot at init time, so autosuggestions' position relative to completion plugins does not matter.

### `atinit` / `atload` in `for` blocks

Both execute **per plugin, not per block** (`zinit.zsh:1707, 1875`). `zinit atinit'echo hi' for A B C` prints "hi" three times.

- `atinit` — runs BEFORE sourcing the plugin's `.zsh` files
- `atload` — runs AFTER sourcing the plugin's `.zsh` files
- In turbo mode, both run when the scheduler fires (first `precmd`), not during `.zshrc` parsing

---

## Troubleshooting

### Completion doesn't work for a specific tool

Run through these steps in order:

**1. Does the `_*` file exist?**

```zsh
# Check if zinit installed the completion
ls -la $ZINIT[COMPLETIONS_DIR]/_<tool>

# Check if it's anywhere in fpath
print -l $^fpath/_<tool>(N)
```

If the file doesn't exist in `$ZINIT[COMPLETIONS_DIR]`, the `atclone` didn't run or failed. Reinstall:

```zsh
zinit delete --all <tool>-completions
exec zsh
```

**2. Is the completion function loaded?**

```zsh
# Check if compinit picked it up
whence -v _<tool>
```

If `whence` says "not found", compinit hasn't scanned the file. This means either `zicompinit` didn't run, or it ran before the symlink was created.

**3. Did `zicdreplay` replay the `compdef` call?**

Some tools register completions via `compdef` at runtime (Type F with `eval"tool init zsh"`, like zoxide, atuin). These need `zicdreplay` — the `_*` file check above won't find them.

```zsh
# Check if the completion is registered (not file-based)
echo $_comps[<tool>]
```

**4. Is `compinit` even running?**

```zsh
# Check when compinit last ran
ls -la ~/.zcompdump
```

If `.zcompdump` is old or missing, `zicompinit` isn't firing. Verify the `zicompinit; zicdreplay` block is the last item in L2.

### General diagnostic commands

```zsh
# List all completions zinit manages
zinit completions

# Check load times — verify zicompinit is listed
zinit times

# List all plugins in declaration order
zinit loaded

# Check what's in fpath (completion search path)
echo $fpath | tr ' ' '\n' | grep zinit

# Check what functions are registered for a command
echo $_comps[git]
```

### Common failures

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `_<tool>` not in `$ZINIT[COMPLETIONS_DIR]` | `atclone` failed — missing `nocompile` on Type A | Add `nocompile`, reinstall |
| `_<tool>` exists but `whence -v _<tool>` fails | `zicompinit` didn't run after the symlink was created | Check `zicompinit` is the last L2 item |
| `$_comps[<tool>]` is empty | `compdef` call wasn't replayed — missing `zicdreplay` | Add `zicdreplay` after `zicompinit` |
| `.zcompdump` is stale | `zicompinit` was never called | Verify the `zicompinit; zicdreplay` block exists in config |
| Tab completes but autosuggestions don't suggest | Different issue — autosuggestions queries are lazy, check `ZSH_AUTOSUGGEST_STRATEGY` | Ensure `completion` is in the strategy list |

### Isolating the problem

To confirm a completion issue is specifically caused by ordering (not a missing file or broken `atclone`):

```zsh
# Manually re-run compinit and replay
zicompinit
zicdreplay

# Now test tab-completion
<tool> <TAB>
```

If completions work after manual `zicompinit; zicdreplay` but not on a fresh shell, the `zicompinit` block is incorrectly placed or missing.

---

## Reference

### Ice modifier reference

| Ice | Description |
|-----|-------------|
| `as'completion'` | Mark plugin as a completion; discover and install `_*` files |
| `as"command"` | Mark plugin as a command (binary); skip compilation; still detect `_*` files |
| `as"null"` | No files to source — only `eval` matters |
| `nocompile` | Skip compilation; required for Type A with `zdharma-continuum/null` |
| `nocompile'!'` | Compile after `make` and `atclone` (when Makefile installs scripts) |
| `atclone"cmd"` | Run command after cloning |
| `atpull"%atclone"` | Repeat `atclone` on update (only when new commits are downloaded) |
| `run-atpull` | Force `atpull` to always run, even without new commits |
| `eval"cmd"` | Source stdout as a script |
| `has"cmd"` | Only load when command is available in `$PATH` |
| `id-as"name"` | Unique nickname for the plugin (required for `zdharma-continuum/null`) |
| `src"file"` | Source a specific file from the plugin after load |
| `wait"0a"` | Turbo-load with priority suffix `a`=1 (L1 infrastructure) |
| `wait'!0'` | Turbo-load with immediate `zle .reset-prompt` after load |
| `zicompinit` | Helper: runs `compinit`. Use in `atload`/`atinit` hooks |
| `zicdreplay` | Helper: replays captured `compdef` calls. Must run after `zicompinit` |
| `from"gh-r"` | Download from GitHub releases instead of cloning the repo |
| `bpick"pattern"` | Pick which asset to download from GitHub releases |
| `mv"src -> dst"` | Rename/move files after download |

### Source code index

| Mechanism | File | Lines |
|-----------|------|-------|
| Scheduler (`@zinit-scheduler`) | `zinit.zsh` | 2491-2592 |
| Task submission (`.zinit-submit-turbo`) | `zinit.zsh` | 2445-2462 |
| Run task (`.zinit-run-task`) | `zinit.zsh` | 2390-2438 |
| compdef hijacking (`:zinit-tmp-subst-compdef`) | `zinit.zsh` | 743-754 |
| compdef replay (`.zinit-compdef-replay`) | `zinit.zsh` | 1890-1913 |
| `.zinit-compinit` | `zinit-install.zsh` | 617-658 |
| `for` block processing loop | `zinit.zsh` | 2729-2912 |
| `atinit` execution | `zinit.zsh` | 1707 |
| `atload` execution | `zinit.zsh` | 1875 |
| Scheduler precmd hook registration | `zinit.zsh` | 3268 |
| Auto compinit after plugin load | `zinit.zsh` | 1303, 1317 |
| `zicompinit` | `zinit.zsh` | 3178-3181 |
| `zicdreplay` | `zinit.zsh` | 3165-3167 |
| `zicompdef` | `zinit.zsh` | 3185-3187 |
