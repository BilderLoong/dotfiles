# Zinit Completion Installation Guide

How to install zsh completions for CLI tools using zinit. Covers three types of completion sources: command stdout snippets, side-effect commands, and independent completion files.

---

## TL;DR

Copy-paste the pattern that matches your tool.

### Type 1: Tool outputs completion to stdout

```zsh
# e.g. ast-grep completions zsh → #compdef ast-grep ...
zinit ice as'completion' id-as"TOOL-completions" has"TOOL" nocompile \
    atclone"TOOL completions zsh > _TOOL" \
    atpull"%atclone" run-atpull
zinit light zdharma-continuum/null
```

### Type 2: Tool installs completions as a side effect

```zsh
# e.g. syncthing install-completions → bashcompinit + complete -C
zinit ice wait lucid has'TOOL' id-as'TOOL-completions' \
    eval"TOOL install-completions"
zinit light zdharma-continuum/null
```

### Type 3: Pre-existing completion file

```zsh
# From Oh My Zsh
zinit ice as"completion"
zinit snippet OMZP::docker/_docker

# From GitHub release
zinit ice as"completion" from"gh-r" bpick"completions_zsh" \
    mv"completions_zsh -> _tldr"
zinit light dbrgn/tealdeer
```

### Hybrid: Binary installation + completion generation

```zsh
# e.g. atuin: install binary from gh-r, generate completions during atclone
zinit ice as"command" from"gh-r" bpick"TOOL-*.tar.gz" mv"TOOL*/TOOL -> TOOL" \
    atclone"./TOOL init zsh > init.zsh; ./TOOL gen-completions --shell zsh > _TOOL" \
    atpull"%atclone" src"init.zsh"
zinit light user/repo
```

---

## Why `nocompile` is required

For **Type 1** completions using `zdharma-continuum/null` with `atclone`, `nocompile` is **not optional** — it's a hard requirement. Here's why.

### zinit's execution order

```
1. Clone plugin
2. !atclone hooks  ← compilation runs HERE (before atclone)
3. atclone         ← your command runs here, creating _TOOL
4. completion installation  ← zinit discovers _TOOL and installs it
```

The critical point: **compilation happens at step 2, before `atclone` creates your completion file.**

### The failure chain (without `nocompile`)

```
!atclone hooks fire
  → ∞zinit-compile-plugin-hook runs
    → nocompile NOT set → hook does NOT skip
    → calls .zinit-compile-plugin
      → calls .zinit-first on the empty null directory
      → FINDS NOTHING (no files to compile)
      → returns exit code 1 (failure)
    → hook_rc = 1
    → retval gets set to 1
  → subshell returns 1
    → `) || return $?` triggers
      → .zinit-setup-plugin-dir exits EARLY
        → completion installation at line 501 is NEVER REACHED
```

**Result:** `_TOOL` file is never discovered. Completion is never installed.

### The success chain (with `nocompile`)

```
!atclone hooks fire
  → ∞zinit-compile-plugin-hook runs
    → nocompile IS set → returns 0 immediately (skipped)

atclone runs → creates _TOOL ✓

atclone hooks fire
  → compile hook runs again
    → hook is atclone, nocompile ≠ '!' → returns 0 (skipped)

retval = 0
  → subshell succeeds
    → `) || return $?` does NOT trigger
      → reaches completion installation
        → globs for _* files → finds _TOOL → installs it ✓
```

### Source code reference

| What | Where |
|------|-------|
| Compile hook condition | `zinit-install.zsh:2335` |
| Subshell with early return | `zinit-install.zsh:460-493` |
| Completion installation | `zinit-install.zsh:501-502` |
| `.zinit-compile-plugin` finds nothing | `zinit-autoload.zsh:1028-1050` |

### When `nocompile` is NOT needed

1. Basic when you can successfully complied. so the there is no failed compilation step that bails out the process before completion installation. 
     - **Hybrid** (`as"command"`): zinit skips compilation when `as = command` (line 955: `if [[ ${ICE[as]} != command ]]; then`)
2. There is no compilation step at all (e.g. `as"command"`).
     - **Type 2** (side-effect commands): No `atclone`, so no compilation hook runs
     - **Type 3** (independent snippets): `as"completion"` handles everything directly

---

## Type 1: Command stdout snippets

Tools that output a valid zsh completion file (`#compdef TOOL`) to stdout when you run a command like `tool completions zsh` or `tool completion`.

**Examples:** `ast-grep completions zsh`, `opencode completion`, `poetry completions zsh`

### Approach A: `nocompile` + `as'completion'`

```zsh
zinit ice as'completion' id-as"opencode-completions" has"opencode" nocompile \
    atclone"opencode completion zsh > _opencode" \
    atpull"%atclone" run-atpull
zinit light zdharma-continuum/null
```

**Why each ice is needed:**

| Ice | Purpose |
|-----|---------|
| `as'completion'` | Tells zinit to treat this as a completion plugin; discovers and installs `_*` files |
| `nocompile` | Skips the compilation step that fails on empty plugins and bails out before completion installation |
| `id-as` | Gives the null plugin a unique name to avoid conflicts |
| `has` | Only loads when the tool is installed (skips if not found) |
| `atclone` | Generates the completion file after cloning the empty plugin |
| `atpull"%atclone"` | Re-runs the same atclone command on update |
| `run-atpull` | Forces atpull to run even when `zdharma-continuum/null` has no new commits |

### Approach B: `creinstall`

```zsh
zinit ice id-as"opencode-completions" has"opencode" nocompile \
    atclone"opencode completion zsh > _opencode; zinit creinstall -q opencode-completions" \
    atpull"%atclone" run-atpull
zinit light zdharma-continuum/null
```

Generates the completion file AND explicitly installs it via `zinit creinstall`. The `creinstall` command looks for `_*` files in the plugin directory and creates symlinks in `$ZINIT[COMPLETIONS_DIR]`. Still requires `nocompile` to avoid the same compilation failure.

### Wrong examples

| # | Wrong code | Why it fails |
|---|-----------|--------------|
| 1 | `eval"opencode completion zsh"` | `eval` sources stdout as a script — it defines the completion function in the current shell but never installs it into `$fpath`. Completions are never discovered by `compinit`. |
| 2 | Missing `nocompile` | Compilation at `!atclone` fails (empty plugin), returns non-zero, bails out before completion installation. See [Why `nocompile` is required](#why-nocompile-is-required). |
| 3 | Missing `as'completion'` | The `_*` file is generated but zinit doesn't know to install it as a completion. It sits in the plugin directory but is never symlinked to `$ZINIT[COMPLETIONS_DIR]`. |
| 4 | Missing `run-atpull` | `atpull"%atclone"` only fires when new commits are downloaded. For `zdharma-continuum/null` (which rarely updates), it never fires, so completions are never regenerated. |
| 5 | `as'completion'` + `eval"command completions"` | Combines two wrong approaches. `eval` sources stdout (not useful for completions), and without `atclone`, no file is generated. |

---

## Type 2: Command with side effect

Tools that run a command which installs completions as a side effect. The command outputs bash-style completion setup commands (`complete -C`), not a zsh completion file.

**Examples:** `syncthing install-completions`

### Correct approach

```zsh
zinit ice wait lucid has'syncthing' id-as'syncthing-completions' \
    eval"syncthing install-completions"
zinit light zdharma-continuum/null
```

`syncthing install-completions` outputs:
```
autoload -U +X bashcompinit && bashcompinit
complete -C /opt/homebrew/bin/syncthing syncthing
```

These are bash-style completion commands that work in zsh via `bashcompinit`. The `eval` ice captures stdout and sources it. No `nocompile` needed because there's no `atclone` to run.

### Wrong examples

| # | Wrong code | Why it fails |
|---|-----------|--------------|
| 1 | `as'completion' atclone"syncthing install-completions > _syncthing"` | `syncthing install-completions` outputs bash-style commands, not a zsh completion file. The `_syncthing` file would contain `complete -C` instead of `#compdef syncthing`. |
| 2 | `as'completion' nocompile atclone"syncthing install-completions > _syncthing" atpull'%atclone'` | Same issue — the generated file is not a valid zsh completion. |
| 3 | `creinstall` approach for this type | `creinstall` expects a `#compdef` file. The bash-style output from `install-completions` won't work. |

---

## Type 3: Independent completion snippets

Pre-existing completion files that can be downloaded directly from a URL or from a repository like Oh My Zsh. The completion file already exists — no generation needed.

### Correct approach

```zsh
# From Oh My Zsh — a specific completion file from a plugin
zinit ice as"completion"
zinit snippet OMZP::docker/_docker

# From a GitHub release — download the completion file directly
zinit ice as"completion" from"gh-r" bpick"completions_zsh" \
    mv"completions_zsh -> _tldr"
zinit light dbrgn/tealdeer
```

The `as"completion"` ice tells zinit to treat the file as a completion and install it into `$ZINIT[COMPLETIONS_DIR]`.

### Wrong examples

| # | Wrong code | Why it fails |
|---|-----------|--------------|
| 1 | `zinit snippet OMZP::docker/_docker` (missing `as"completion"`) | zinit treats the file as a source plugin, tries to source it as a regular script. The `#compdef` header is ignored. |
| 2 | `atclone"curl -sL URL > _TOOL"` with `as'completion'` | This technically works but is overcomplicated — just use `snippet` with `as"completion"` directly. The `atclone` approach adds unnecessary complexity. |

---

## Hybrid: Binary + completion generation

Some tools install a binary (e.g., from GitHub releases) and also generate completions during setup. Use `as"command"` for the binary and let zinit discover `_*` files automatically.

### Correct approach

```zsh
# atuin: install binary from gh-r, generate completions during atclone
zinit ice wait lucid as"command" from"gh-r" bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" \
    atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
    atpull"%atclone" src"init.zsh"
zinit light atuinsh/atuin
```

**Why this works without `nocompile`:** When `as"command"` is set, zinit skips the compilation step entirely (`zinit-install.zsh:955`: `if [[ ${ICE[as]} != command ]]; then`). No compilation failure, no early bailout.

**Why `as"command"` (not `as'completion'`):** The primary purpose is to install a binary. The completion file `_atuin` is a side effect. With `as"command"`, zinit still detects `_*` files and installs them as completions.

**Same pattern for starship:**
```zsh
zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
zinit light starship/starship
```

---

## Verification & debugging

### Check if a completion file exists in `$fpath`

```zsh
# Find all copies of a completion file across fpath
print -l $^fpath/_ast-grep(N)

# Check if a completion function is defined
whence -v _ast-grep

# Check the completions registry
zinit completions
```

### Common output

```
/opt/homebrew/share/zsh/site-functions/_ast-grep     # ← installed by Homebrew
/Users/birudo/.local/share/zinit/completions/_ast-grep  # ← installed by zinit
```

If you see the Homebrew path but not the zinit path, the tool's completions are being provided by Homebrew (which is fine — zinit is redundant in that case).

### Clear and reinstall a completion

```zsh
# Delete the plugin entirely, then reload shell to re-clone
zinit delete --all TOOL-completions
exec zsh

# Or just reinstall completions
zinit creinstall TOOL-completions
```

---

## Ice modifier reference

| Ice | Description |
|-----|-------------|
| `as'completion'` | Mark plugin as a completion; discover and install `_*` files to `$ZINIT[COMPLETIONS_DIR]` |
| `as"command"` | Mark plugin as a command (binary); skip compilation; still detect `_*` files for completion |
| `nocompile` | Skip compilation entirely; required for empty plugins with `atclone` that generate files |
| `nocompile'!'` | Compile after `make` and `atclone` (useful when Makefile installs scripts) |
| `atclone"cmd"` | Run command after cloning (e.g., generate completion file) |
| `atpull"%atclone"` | Repeat `atclone` on update (only when new commits are downloaded) |
| `run-atpull` | Force `atpull` to always run, even without new commits |
| `eval"cmd"` | Source stdout as a script (useful for bash-style completions via `bashcompinit`) |
| `nocompletions` | Skip completion detection/installation (opposite of `completions`) |
| `completions` | Explicitly enable completion detection (redundant with `as'completion'`) |
| `has"cmd"` | Only load when the given command is available in `$PATH` |
| `id-as"name"` | Give the plugin a unique nickname (required for `zdharma-continuum/null`) |
