# `.zshenv' is sourced on all invocations of the shell, unless the -f option is set. It should contain commands to set the command search path, plus other important environment variables. `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.
# Source: https://zsh.sourceforge.io/Intro/intro_3.html
skip_global_compinit=1

# ── PATH exports live HERE, not in .zshrc ────────────────────────────────
# Why: zsh sources .zshrc ONLY for interactive shells. Non-interactive
# invocations (scripts, cron-spawned zsh, other agents' shells) never read
# it, so binaries added to PATH there end up "installed but unusable"
# outside a terminal. .zshenv is sourced for EVERY zsh invocation, so PATH
# exports here are visible everywhere — interactive, login, and non-interactive.
#
# Keep this section to cheap string operations ONLY: no subprocesses, no
# compinit, no output. Measured cost of the whole block: ~0.26 ms (≈0.2% of
# interactive startup). The [[ ... ]] guards make entries idempotent — they
# skip re-prepending when the dir is already on PATH (interactive shells may
# add the same dir elsewhere), so no duplicates accumulate.

# bun — installer writes the binary + shims to ~/.bun/bin
export BUN_INSTALL="$HOME/.bun"
[[ ":$PATH:" != *":$BUN_INSTALL/bin:"* ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# personal scripts (setproxy, merge_json.py, …)
[[ ":$PATH:" != *":$HOME/bin:"* ]] && export PATH="$HOME/bin:$PATH"

# Go tool shims (gopls, staticcheck) — the `go` binary itself is Homebrew
[[ ":$PATH:" != *":$HOME/go/bin:"* ]] && export PATH="$HOME/go/bin:$PATH"

# pnpm global shims (cline, …) — the `pnpm` binary itself is Homebrew
export PNPM_HOME="$HOME/Library/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# rustup/cargo toolchain — explicit export replaces sourcing ~/.cargo/env
# (same effect, no subprocess); the env script is just this guarded export
[[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Haskell toolchain (GHC/cabal/stack via ghcup)
[[ ":$PATH:" != *":$HOME/.ghcup/bin:"* ]] && export PATH="$HOME/.ghcup/bin:$PATH"
