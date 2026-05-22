# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

`.stowrc` defaults to `--no-folding` — stow creates real directories at the target and only symlinks individual files (never whole directories).

## Quick Reference
Run `stow --help` for help. Don't guess.

All commands assume the CWD is the dotfiles (stow dir) directory. The stow dir (`-d`) is the current directory; the target (`-t`) is `~` (must be explicit, see note below).

> **Why `-t ~` is always needed:** The default target is the *parent* of the stow dir, which would be `~/Projects/`. Always pass `-t ~` to link into your home directory.

## Directory Structure

Two patterns for how packages mirror the target path.

### Pattern A: flat dotfile (e.g. `.zshrc`, `.gitconfig`)

The file sits at the package root. Its path relative to the package matches the path under `~`.

```
zsh/
  .zshrc       → ~/.zshrc
  .zshenv      → ~/.zshenv
  zsh/
    custom/    → ~/zsh/custom/
```

### Pattern B: XDG `.config/<app>/` nesting (e.g. Alacritty, Kitty, mpv)

The package has a `.config/` prefix so the file lands under `~/.config/`.

```
alacritty/
  .config/
    alacritty/
      alacritty.toml  → ~/.config/alacritty/alacritty.toml
```

### Pattern C: nested non-dotfile prefix (e.g. `bin/`)

Extra nesting so files land outside `~/.config/` without a leading dot.

```
bin/
  bin/
    setproxy  → ~/bin/setproxy
```

`./termux`: contains all config files used for Termux on my "nex".

---

## Scenarios

### 1. Install on a new machine (bulk setup)

After cloning the repo, re-link every package.

#### Option A: keep only committed dotfiles (discard all local)

```bash
git checkout HEAD              # ensure clean working tree
stow */ -t ~ --adopt           # move any pre-existing ~ dotfiles into the repo, then symlink
git checkout HEAD              # discard adopted content; keep only committed versions in the repo
stow --restow */ -t ~          # recreate all symlinks pointing to committed repo files
```

**Why the `git checkout HEAD` sandwich?**
- `stow` fails if a target path already holds a real file (not a symlink).
- `--adopt` solves this by *moving* the existing file into the stow package, replacing the target with a symlink pointing back.
- On a fresh install, those pre-existing files are likely system defaults — you don't want them committed. `git checkout HEAD` discards the adopted content, restoring the repo to its committed state.
- `--restow` then recreates the symlinks, now pointing to *your* committed dotfiles.

#### Option B: review adopted files, keep what's useful

Sometimes pre-existing dotfiles on the new machine contain configurations worth keeping (machine-specific paths, API keys, etc.). Instead of discarding everything, inspect the diff and selectively commit or revert.

```bash
git checkout HEAD              # ensure clean working tree
stow */ -t ~ --adopt           # move all pre-existing ~ dotfiles into the repo, then symlink

# Now review everything that was absorbed
git diff                        # see all adopted content
git status                      # see which files were changed

# Discard files you don't want — restores the committed version for that file
git checkout -- zsh/.zshrc

# Keep files that have useful local settings
# (they're already staged by --adopt, write a meaningful message)
git commit -m "adopt machine-specific configs from hostname"

stow --restow */ -t ~           # ensure all symlinks are consistent
```

For a single package: `stow zsh -t ~`.

### 2. Add a brand-new package from an existing config

You have `~/.config/kitty/kitty.conf` on disk. It's not yet in the dotfiles repo.

```bash
# Create the package structure mirroring the target
mkdir -p ~/Projects/dotfiles/kitty/.config/kitty

# Move the existing config into the repo
mv ~/.config/kitty/kitty.conf ~/Projects/dotfiles/kitty/.config/kitty/kitty.conf

# Stow to create the symlink back from ~ to the repo
stow kitty -t ~

# Commit
git add kitty
git commit -m "add kitty config"
```

For a flat dotfile (no `.config/`): `mkdir -p kitty && mv ~/.kittyrc kitty/.kittyrc && stow kitty -t ~`.

### 3. Resolve conflicts: stowed file already exists as a real file at target

A package exists in the repo, but the target already has a real file (not a symlink) at the same path.

**Option A — adopt it into the repo (preserve local content):**

```bash
stow kitty -t ~ --adopt   # moves ~/.config/kitty/kitty.conf into the repo, creates symlink
# Review what was adopted:
git diff
# Discard individual adopted files if the repo version is preferred:
git checkout -- kitty/.config/kitty/kitty.conf
git commit -m "adopt kitty config"
```

**Option B — keep the repo version, discard the local one:**

```bash
m ~/.config/kitty/kitty.conf     # remove the conflicting file
stow -R kitty -t ~                # restow creates the symlink to the repo version
```

**Option C — manually reconcile:**

```bash
mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.bak
stow kitty -t ~
diff ~/.config/kitty/kitty.conf.bak ~/Projects/dotfiles/kitty/.config/kitty/kitty.conf
# Merge what you want, then rm the backup
```

### 4. Remove a dotfile from both repo and target

Delete the file in both places.

```bash
# Remove the symlink at the target first
rm ~/.zshenv

# Remove the source file from the stow package
rm ~/Projects/dotfiles/zsh/.zshenv

# Commit
git add zsh && git commit -m "remove .zshenv"
```

No stow command is needed — the remaining symlinks for the package are unaffected.

### 5. Remove a dotfile from repo, keep as real file at target

"Sodomize" the symlink: replace it with an actual copy of the content, then delete the repo source.

```bash
# Remove the symlink at target (does not delete the source)
rm ~/.zshenv

# Copy the source content to the target as a real file
cp ~/Projects/dotfiles/zsh/.zshenv ~/.zshenv

# Remove the source from the repo
rm ~/Projects/dotfiles/zsh/.zshenv

# Commit
git add zsh && git commit -m "remove .zshenv from stow, keep as real file"
```

### 6. Unstow an entire package

Remove all symlinks for a package (but the package directory stays in the repo).

```bash
stow -D kitty -t ~   # removes all symlinks created by this package
```

To also delete the package from the repo:

```bash
stow -D kitty -t ~
rm -rf ~/Projects/dotfiles/kitty
git rm -r kitty && git commit -m "remove kitty"
```

### 7. Add a new file to an already-stowed package

You add a new config file inside an existing package directory.

```bash
# Move the file into the package at the right path
mv ~/.config/kitty/kitty2.conf ~/Projects/dotfiles/kitty/.config/kitty/kitty2.conf

# Restow to pick up the new file (unstow + stow)
stow -R kitty -t ~

git add kitty && git commit -m "add kitty2 config"
```

### 8. Preview changes (dry-run)

See what stow will do without making any changes.

```bash
stow -n kitty -t ~      # what would stow do?
stow -n -D kitty -t ~   # what would unstow do?
stow -n -R kitty -t ~   # what would restow do?
```

---

## Special Cases

### Rime on macOS

Stow into a non-standard target:

```bash
stow -S Rime -t ~/Library/Rime
```

---

## Reference

- [Delete all target links and files before running GNU Stow](https://unix.stackexchange.com/questions/705401/delete-all-target-links-and-files-before-running-gnu-stow)
