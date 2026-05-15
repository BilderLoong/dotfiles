---
name: stow-dotfiles
description: Guide for managing dotfiles with GNU Stow in <dotfiles-repo>. Use when users need to install, update, add, remove, or manage dotfiles managed by stow. Triggers on "stow", "dotfiles", "manage dotfiles", "install dotfiles", "symlink config", "stow config", "add dotfile", "remove dotfile".
---

# GNU Stow — Dotfiles Management

## Overview

This skill covers managing dotfiles in `<dotfiles-repo>` with GNU Stow. Each top-level directory is a **stow package** — its internal path structure mirrors the target (`~`).

**Key facts:**
- **Stow dir:** `<dotfiles-repo>` (the repo root)
- **Target:** `~` (always explicit: `-t ~` — default would be parent of stow dir)
- **`.stowrc`** contains `--no-folding` → creates real directories, symlinks only individual files
- Two patterns: flat dotfile (e.g. `zsh/.zshrc → ~/.zshrc`) and XDG nested (e.g. `kitty/.config/kitty/kitty.conf → ~/.config/kitty/kitty.conf`)

## When to Use

Trigger this skill when the user asks to:
- Install/re-link/setup dotfiles on a machine
- Add a new application config to their dotfiles
- Remove a config from management
- Unmanage a config (keep as real file, remove from stow)
- Resolve conflicts between stowed and existing files
- Stow/unstow/re-stow packages

## Required Context

Before any operation:
- **Ask the user for `<dotfiles-repo>`** once per session — their dotfiles repository path. Never assume or hardcode it.
- All commands run from `<dotfiles-repo>` unless noted otherwise.
- Confirm `<dotfiles-repo>` exists and is a git repo.
- Confirm stow is available (`which stow`).

---

## Scenarios

### 1. Install dotfiles on a new machine (bulk setup)

Two approaches. Default to Option A unless the user wants to preserve local changes.

#### Option A — discard all pre-existing files (clean install)

```bash
git checkout HEAD
stow */ -t ~ --adopt
git checkout HEAD
stow --restow */ -t ~
```

This moves every pre-existing dotfile into the repo, discards the adopted content, then re-symlinks from the committed versions.

#### Option B — review and selectively keep adopted files

```bash
git checkout HEAD
stow */ -t ~ --adopt

# Review what was absorbed
git diff
git status

# Discard files the user doesn't want (restores committed version)
# git checkout -- <path>

# Commit what the user wants to keep
git add <kept-files>
git commit -m "adopt machine-specific configs from $(hostname)"

stow --restow */ -t ~
```

### 2. Install a single package

```bash
stow <pkg> -t ~
```

### 3. Add a brand-new package from an existing config

User has a config at `~/.config/<app>/` not yet tracked.

```bash
# XDG-style (e.g. kitty)
mkdir -p <dotfiles-repo>/<pkg>/.config/<app>
mv ~/.config/<app>/<config-file> <dotfiles-repo>/<pkg>/.config/<app>/<config-file>
stow <pkg> -t ~
git add <pkg>
git commit -m "add <pkg> config"

# Flat dotfile style (e.g. .myrc)
mkdir -p <dotfiles-repo>/<pkg>
mv ~/<dotfile> <dotfiles-repo>/<pkg>/<dotfile>
stow <pkg> -t ~
git add <pkg>
git commit -m "add <pkg> config"
```

### 4. Resolve conflicts (package exists, target has a real file)

**Option A — adopt the local file into the repo (preserve local content):**

```bash
stow <pkg> -t ~ --adopt
git diff
# If some adopted files should be discarded:
# git checkout -- <path>
git commit -m "adopt <pkg> config"
```

**Option B — keep the repo version, discard the local file:**

```bash
rm ~/<path-to-dotfile>
stow -R <pkg> -t ~
```

**Option C — manually reconcile:**

```bash
mv ~/<path-to-dotfile> ~/<path-to-dotfile>.bak
stow <pkg> -t ~
diff ~/<path-to-dotfile>.bak <dotfiles-repo>/<pkg>/<path-to-dotfile>
# Merge what the user wants, then rm the backup
```

### 5. Add a new file to an already-stowed package

```bash
mv ~/<path-to-new-file> <dotfiles-repo>/<pkg>/<path-to-new-file>
stow -R <pkg> -t ~
git add <pkg>
git commit -m "add <file> to <pkg>"
```

### 6. Remove a dotfile from BOTH repo and target

```bash
rm ~/<path-to-dotfile>
rm <dotfiles-repo>/<pkg>/<path-to-dotfile>
git add <pkg>
git commit -m "remove <file> from <pkg>"
```

### 7. Remove a dotfile from repo, keep as real file at target

Replace the symlink with an actual copy, then delete the repo source.

```bash
rm ~/<path-to-dotfile>
cp <dotfiles-repo>/<pkg>/<path-to-dotfile> ~/<path-to-dotfile>
rm <dotfiles-repo>/<pkg>/<path-to-dotfile>
git add <pkg>
git commit -m "remove <file> from <pkg>, keep as real file"
```

### 8. Unstow an entire package (remove all its symlinks)

```bash
stow -D <pkg> -t ~
```

To also delete the package from the repo:

```bash
stow -D <pkg> -t ~
rm -rf <dotfiles-repo>/<pkg>
git rm -r <pkg>
git commit -m "remove <pkg>"
```

### 9. Dry-run / preview

```bash
stow -n <pkg> -t ~       # what would stow do?
stow -n -D <pkg> -t ~    # what would unstow do?
stow -n -R <pkg> -t ~    # what would restow do?
```

---

## Special Cases

### Rime on macOS

```bash
stow -S Rime -t ~/Library/Rime
```

### Termux

`termux/` package targets `~` — used on Android/Termux via the "nex" device.

---

## Safety Rules

- Always use `-n` (dry-run) first when uncertain
- Never stow without `-t ~` — default target is parent of stow dir
- After `--adopt`, always review with `git diff` before committing
- After stowing new paths, verify with `ls -la <target-path>` to confirm it's a symlink
