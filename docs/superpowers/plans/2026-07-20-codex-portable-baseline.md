# Codex Portable Baseline Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Store a curated, portable Codex baseline in the dotfiles repository and symlink it into `~/.codex` with GNU Stow.

**Architecture:** Add one `codex` Stow package whose `.codex` subtree mirrors the user target. The package owns only `AGENTS.md` and a curated `config.toml` initially; authored prompts and skills are added later as real user-authored files. Codex continues to own all runtime state in the normal `~/.codex` directory.

**Tech Stack:** GNU Stow, Git, TOML, macOS shell utilities.

## Global Constraints

- Stow target is always explicit: `-t ~`.
- Preserve the live `AGENTS.md` byte-for-byte.
- Curate `config.toml` with an allowlist; never commit credentials, absolute paths, project trust records, application state, caches, sessions, or downloaded binaries.
- Do not add empty `prompts/` or `skills/` directories, placeholder files, system skills, or plugin caches.
- Keep all live-file backups outside the repository under a unique directory in `/private/tmp`.

---

### Task 1: Preflight and create recoverable live-file backups

**Files:**
- Create: `/private/tmp/codex-stow-backup-2026-07-20/AGENTS.md`
- Create: `/private/tmp/codex-stow-backup-2026-07-20/config.toml`
- Modify: none
- Test: shell checks below

**Interfaces:**
- Consumes: `~/.codex/AGENTS.md`, `~/.codex/config.toml`, `/Users/birudo/Projects/dotfiles/.stowrc`
- Produces: a verified backup directory used by Task 2 if any migration step must be rolled back

- [ ] **Step 1: Confirm the repository and live targets are in the expected starting state**

Run:

```bash
git -C /Users/birudo/Projects/dotfiles status --short
command -v stow
test -f /Users/birudo/.codex/AGENTS.md
test -f /Users/birudo/.codex/config.toml
test ! -L /Users/birudo/.codex/AGENTS.md
test ! -L /Users/birudo/.codex/config.toml
```

Expected: a clean Git worktree, a path to `stow`, and zero exit status for every file and non-symlink assertion.

- [ ] **Step 2: Check that no other Codex process can rewrite the two files during the migration**

Run:

```bash
pgrep -fl 'Codex|codex'
```

Expected: review every listed process. Close any other Codex desktop or CLI process before changing either live file; the migration continues only after the active writers are stopped.

- [ ] **Step 3: Create and verify a unique backup outside the repository**

Run:

```bash
test ! -e /private/tmp/codex-stow-backup-2026-07-20
mkdir /private/tmp/codex-stow-backup-2026-07-20
cp /Users/birudo/.codex/AGENTS.md /private/tmp/codex-stow-backup-2026-07-20/AGENTS.md
cp /Users/birudo/.codex/config.toml /private/tmp/codex-stow-backup-2026-07-20/config.toml
cmp /Users/birudo/.codex/AGENTS.md /private/tmp/codex-stow-backup-2026-07-20/AGENTS.md
cmp /Users/birudo/.codex/config.toml /private/tmp/codex-stow-backup-2026-07-20/config.toml
```

Expected: both `cmp` commands exit with status zero. The backup directory is `/private/tmp/codex-stow-backup-2026-07-20`.

- [ ] **Step 4: Commit**

No repository files change in this task. Do not create a commit.

### Task 2: Create the curated `codex` Stow package

**Files:**
- Create: `codex/.codex/AGENTS.md`
- Create: `codex/.codex/config.toml`
- Test: `stow -n codex -t ~`

**Interfaces:**
- Consumes: the verified backups from Task 1 and the live configuration structure
- Produces: the two portable files that Task 3 links into `~/.codex`

- [ ] **Step 1: Create the package directory and move the unchanged instructions into it**

Run:

```bash
mkdir -p /Users/birudo/Projects/dotfiles/codex/.codex
mv /Users/birudo/.codex/AGENTS.md /Users/birudo/Projects/dotfiles/codex/.codex/AGENTS.md
cmp /private/tmp/codex-stow-backup-2026-07-20/AGENTS.md /Users/birudo/Projects/dotfiles/codex/.codex/AGENTS.md
```

Expected: the comparison exits with status zero; `~/.codex/AGENTS.md` no longer exists until Task 3 creates its symlink.

- [ ] **Step 2: Build the curated baseline from the backed-up configuration**

Create `codex/.codex/config.toml` with exactly this current portable baseline:

```toml
personality = "pragmatic"
model = "gpt-5.6-terra"
model_reasoning_effort = "medium"

[features]
js_repl = false
memories = true

[memories]
generate_memories = true
use_memories = true
disable_on_external_context = true

[plugins."code-simplifier@claude-plugins-official"]
enabled = true
[plugins."commit-commands@claude-plugins-official"]
enabled = true
[plugins."context7@claude-plugins-official"]
enabled = true
[plugins."explanatory-output-style@claude-plugins-official"]
enabled = true
[plugins."frontend-design@claude-plugins-official"]
enabled = true
[plugins."learning-output-style@claude-plugins-official"]
enabled = true
[plugins."superpowers@claude-plugins-official"]
enabled = true
[plugins."documents@openai-primary-runtime"]
enabled = true
[plugins."spreadsheets@openai-primary-runtime"]
enabled = true
[plugins."presentations@openai-primary-runtime"]
enabled = true
[plugins."visualize@openai-bundled"]
enabled = true
[plugins."pdf@openai-primary-runtime"]
enabled = true
[plugins."template-creator@openai-primary-runtime"]
enabled = true
[plugins."sites@openai-bundled"]
enabled = true
[plugins."browser@openai-bundled"]
enabled = true
```

Do not copy any other setting. In particular, omit `notify` and every `[projects.*]`, `[tui.*]`, `[marketplaces.*]`, `[desktop]`, `[hooks.state.*]`, `[mcp_servers.*]`, and `[shell_environment_policy.*]` table.

Expected: the resulting file has only the three permitted top-level keys, the `[features]` and `[memories]` tables, and enabled plugin tables. It contains no token, key, password, `CODEX_HOME`, absolute path, or shell-environment entry.

- [ ] **Step 3: Inspect the candidate before it becomes tracked**

Run:

```bash
rg -n '^\[|^(personality|model|model_reasoning_effort|enabled)[[:space:]]*=' /Users/birudo/Projects/dotfiles/codex/.codex/config.toml
rg -n -i 'token|api[_-]?key|secret|password|authorization|bearer|/Users/birudo|CODEX_HOME|\[projects\.|\[mcp_servers\.|\[shell_environment_policy' /Users/birudo/Projects/dotfiles/codex/.codex/config.toml
```

Expected: the first command lists only allowlisted keys and tables. The second command has no output and exits with status one.

- [ ] **Step 4: Preview the package before linking it**

Run:

```bash
stow -n codex -t ~
```

Expected: the preview creates only `~/.codex/AGENTS.md` and `~/.codex/config.toml` links. It must not mention any other path.

- [ ] **Step 5: Commit**

```bash
git -C /Users/birudo/Projects/dotfiles add codex/.codex/AGENTS.md codex/.codex/config.toml
git -C /Users/birudo/Projects/dotfiles diff --cached --check
git -C /Users/birudo/Projects/dotfiles commit -m "add portable Codex baseline"
```

Expected: Git creates one commit containing exactly the two new package files.

### Task 3: Link, verify, and document future authored content

**Files:**
- Modify: `README.md`
- Test: live symlink and runtime-directory checks

**Interfaces:**
- Consumes: the committed `codex` Stow package
- Produces: two live symlinks and documented rules for future prompts and custom skills

- [ ] **Step 1: Create the live links**

Run:

```bash
stow codex -t ~
```

Expected: Stow completes without conflicts.

- [ ] **Step 2: Verify the exact link targets and the surrounding runtime directory**

Run:

```bash
test -L /Users/birudo/.codex/AGENTS.md
test -L /Users/birudo/.codex/config.toml
test "$(readlink /Users/birudo/.codex/AGENTS.md)" = "/Users/birudo/Projects/dotfiles/codex/.codex/AGENTS.md"
test "$(readlink /Users/birudo/.codex/config.toml)" = "/Users/birudo/Projects/dotfiles/codex/.codex/config.toml"
test -d /Users/birudo/.codex
test ! -L /Users/birudo/.codex
```

Expected: all assertions exit with status zero. The directory remains real so Codex can create untracked local state next to the links.

- [ ] **Step 3: Start Codex and confirm it can use the baseline and generate local runtime state**

Run:

```bash
codex --version
stat -f '%N %Sm' /Users/birudo/.codex/config.toml /Users/birudo/.codex/AGENTS.md
```

Expected: Codex prints its version, both paths remain symlinks, and no link target has been replaced by a regular file.

- [ ] **Step 4: Add the package maintenance rule to the Stow README**

Append this section to `README.md`:

```markdown
### Codex portable baseline

The `codex` package manages only `~/.codex/AGENTS.md` and a curated `~/.codex/config.toml`. Add reusable personal prompts under `codex/.codex/prompts/` and personal skills under `codex/.codex/skills/<skill-name>/` only when they are authored locally. Never add `auth.json`, sessions, caches, plugins, packages, databases, logs, or other generated Codex state.
```

Expected: the README describes the package boundary without changing any unrelated Stow instructions.

- [ ] **Step 5: Commit**

```bash
git -C /Users/birudo/Projects/dotfiles add README.md
git -C /Users/birudo/Projects/dotfiles diff --cached --check
git -C /Users/birudo/Projects/dotfiles commit -m "document Codex Stow package"
```

Expected: Git creates one documentation-only commit.

### Task 4: Verify a clean reusable installation state

**Files:**
- Modify: none
- Test: Git, Stow, and live-file checks

**Interfaces:**
- Consumes: the complete `codex` package and live symlinks
- Produces: evidence that the configuration can be maintained and restored predictably

- [ ] **Step 1: Confirm the package is clean and only owns the intended files**

Run:

```bash
git -C /Users/birudo/Projects/dotfiles status --short
rg --files /Users/birudo/Projects/dotfiles/codex
```

Expected: `git status --short` has no output. The package file list contains exactly `codex/.codex/AGENTS.md` and `codex/.codex/config.toml` until authored prompts or skills are intentionally added.

- [ ] **Step 2: Re-run the Stow dry-run and confirm idempotence**

Run:

```bash
stow -n -R codex -t ~
```

Expected: no conflict or operation that would modify an untracked path.

- [ ] **Step 3: Record the rollback procedure in the implementation handoff**

If a link must be reverted, use the Task 1 backup directory:

```bash
stow -D codex -t ~
cp /private/tmp/codex-stow-backup-2026-07-20/AGENTS.md /Users/birudo/.codex/AGENTS.md
cp /private/tmp/codex-stow-backup-2026-07-20/config.toml /Users/birudo/.codex/config.toml
```

Expected: both original files become regular files again. Do not delete the backup until the user has confirmed normal Codex use.

- [ ] **Step 4: Commit**

No repository files change in this task. Do not create a commit.
