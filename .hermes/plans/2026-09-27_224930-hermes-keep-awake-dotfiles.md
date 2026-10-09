# Hermes Keep-Awake Dotfiles Plan

> **For Hermes:** Use this plan only after the user confirms the target surface.

**Goal:** Keep the Mac awake while a Hermes CLI session runs, using a supported macOS mechanism and the existing GNU Stow setup.

**Architecture:** Hermes Desktop's keep-awake option is a device-local app preference, not a `config.yaml` setting. A Zsh wrapper can tie `caffeinate` to the lifetime of a CLI command. This does not control Hermes Desktop sessions.

**Tech Stack:** macOS `caffeinate`, Zsh, GNU Stow.

---

## Current context

- Dotfiles repo: `/Users/birudo/Projects/dotfiles`.
- The repo uses GNU Stow. The macOS Zsh file is `zsh/zsh/custom/macOS.sh`, loaded by `zsh/zsh/custom/lazy/main.zsh` on Darwin.
- The repo has no Hermes `config.yaml`. `hermes/.hermes.md` contains project instructions, not sleep settings.
- Hermes Desktop already has **Settings → Advanced → Keep computer awake**. It is per-computer and is not tied only to active sessions. Do not add an unsupported key to `config.yaml` or symlink only `keep-awake.json`; Desktop also mirrors this preference in renderer storage.
- The repo currently has user changes in `.gitignore` and `codex/.codex/config.toml`. Preserve them.

## Decision needed before implementation

This dotfile plan covers **CLI sessions only**. For example, running `hermes` in a terminal would run it under `caffeinate -i` until that command exits. It will not keep a Desktop-launched agent awake after the Desktop launcher exits.

For Hermes Desktop, use its built-in **Settings → Advanced → Keep computer awake** switch. If the requirement is to keep the Mac awake only while a Desktop agent turn is active, dotfiles alone do not provide a supported setting for that behavior.

## Proposed steps if the user confirms CLI-only behavior

### Task 1: Add a macOS-only Zsh wrapper

**File:** `zsh/zsh/custom/macOS.sh`

Add a `hermes` function that:

1. Finds the real Hermes executable with Zsh's external-command lookup (`whence -p hermes`), so the function does not call itself.
2. Runs normal CLI invocations under `caffeinate -i` and forwards all arguments and the exit status.
3. Bypasses `caffeinate` for `hermes desktop` and `hermes gui`, because those launchers can exit while the Desktop app continues to run.
4. Returns a clear error if the Hermes executable is not found.

Example behavior:

```text
hermes                 → caffeinate -i <Hermes executable>
hermes chat -q "…"    → caffeinate -i <Hermes executable> chat -q "…"
hermes desktop         → <Hermes executable> desktop
```

Do not edit `hermes/.hermes.md` or create a fake Hermes config key.

### Task 2: Validate the wrapper without running a real agent

- Run `zsh -n zsh/zsh/custom/macOS.sh`.
- Use temporary stub executables named `hermes` and `caffeinate` to check argument forwarding, exit-status forwarding, missing-executable handling, and the `desktop`/`gui` bypass.
- Confirm a normal CLI process creates a macOS idle-sleep assertion with `pmset -g assertions` while it runs, then releases it when it exits.

### Task 3: Preview and apply Stow only after approval

From the repo root:

```bash
stow -n -R zsh -t ~
```

Review the dry-run output. If it has no unwanted changes, apply with:

```bash
stow -R zsh -t ~
```

Then open a new Zsh session and test one bounded Hermes CLI command. Check `pmset -g assertions` during the run and confirm the assertion ends after the command exits.

Do not commit changes unless the user asks. Do not change the existing edits in `.gitignore` or `codex/.codex/config.toml`.

## Acceptance criteria

- The wrapper affects macOS Zsh CLI invocations only.
- `caffeinate` runs only for the lifetime of the wrapped CLI process.
- Desktop launch commands bypass the wrapper and remain controlled by Hermes Desktop's own setting.
- The Stow dry run shows only the intended Zsh package links.
- Existing user edits remain unchanged.
