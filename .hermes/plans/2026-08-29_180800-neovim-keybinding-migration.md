# Neovim Keybinding Migration Implementation Plan

> **For Hermes:** Use subagent-driven-development skill to implement this plan task-by-task.

**Goal:** Apply only the keybinding decisions recorded in `nvim_keybinding_comparison.md` and the completed grill interview, preserving every unrelated AstroNvim mapping and every pre-existing worktree change.

**Architecture:** Follow AstroNvim’s lifecycle split: general/global mappings live in a minimal AstroCore spec; mappings attached with an LSP live in AstroLSP; mappings that participate in Lazy loading or plugin-local setup stay in that plugin’s spec. Add a current Snacks 2.31 AST-grep source, use `treesitter-modules.nvim` for Neovim 0.11 incremental selection, and keep textsubjects explicitly disabled as an incompatibility tombstone.

**Tech Stack:** Neovim 0.11.1, AstroNvim 6.0.4, AstroCore/AstroLSP, Lazy.nvim, Snacks.nvim 2.31.0, Blink, Glance, Conform, Auto Session, UFO, Gitsigns, `ast-grep` 0.28.1, `treesitter-modules.nvim`.

---

## Confirmed behavior

### General and global

- `n/x: zt` uses `zt3<C-Y>` to leave three context lines.
- `n: <Leader>vs` exports the current project to VS Code.
- Keep `n: <Leader>c` unchanged for closing the current buffer.
- Disable only these general mappings: `n: <Leader>w`, `<C-S>`, `<Leader>q`, `<Leader>Q`, `<C-Q>`, and `<Leader>n`.
- Leave all other general mappings unchanged.

### Find and navigation

- `n/i/x: <C-P>` opens the Snacks file picker.
- Disable `n: <Leader>ff`; update the Snacks dashboard `f` action so it still opens Find files.
- `n/i: <C-N>` toggles Neo-tree.
- Disable `n: <Leader>e` and `<Leader>o`.
- `n: <Leader>fA` opens a custom project-wide AST-grep Snacks picker.
- `n: <Leader>fM` opens manual pages.
- `n: <Leader>fS` opens Auto Session search using Snacks.
- Keep `n/x/o: <Leader>fm` as Conform formatting.
- Disable direct LSP formatting on `n/x: <Leader>lf`.
- `n: <Tab>` / `<S-Tab>` navigate next/previous buffers; disable `]b` / `[b` and accept the possible loss of terminal `<C-I>` forward-jumplist behavior.

### LSP

- `n: gd` -> Glance definitions.
- `n: gy` -> Glance type definitions.
- `n: gr` -> Glance references.
- `n: gi` -> Glance implementations.
- Keep `n/x: <Leader>la` as the code-action key and remove native `gra`.
- Keep `n: <Leader>lr` as the rename key and remove native `grn`.
- Remove native `grr`, native `gri`, and AstroLSP `<Leader>lR`.
- Preserve capability conditions on all LSP-attached Glance mappings.
- Leave every other LSP mapping unchanged.

### Completion, folds, Treesitter, and Git

- Blink `i: <A-Space>` uses the current `<C-Space>` completion/docs action chain.
- Disable Blink `<C-Space>`, `<C-N>`, and `<C-P>`.
- Preserve Blink `<C-J>` next and `<C-K>` previous.
- `n: zM` / `zR` call UFO `closeAllFolds()` / `openAllFolds()` rather than native foldlevel-changing commands.
- Add `n: <Leader>gu` for Gitsigns undo-stage-hunk.
- Keep Treesitter loop textobjects on `x/o: ao` / `io`; do not add `al` / `il` because those conflict with Targets’ “last target” modifier.
- Add incremental selection through `MeanderingProgrammer/treesitter-modules.nvim`:
  - `n: \` initializes selection.
  - `x: \` expands by node.
  - `x: <BS>` shrinks by node.
  - `scope_incremental = false`.
- Disable AstroNvim’s normal `\` horizontal-split mapping; leave `|` vertical split unchanged.
- Do not restore textsubjects `.`, `;`, or `i;`.
- Add a disabled `RRethy/nvim-treesitter-textsubjects` spec with a comment and issue URL documenting incompatibility with `nvim-treesitter` `main`.

### Plugin management

Disable all of:

- `<Leader>pi`
- `<Leader>ps`
- `<Leader>pS`
- `<Leader>pu`
- `<Leader>pU`
- `<Leader>pm`
- `<Leader>pM`
- `<Leader>pa`

### AST-grep policy

- Search from the original buffer’s Git root; fall back to the picker/window cwd.
- Include hidden paths such as `.config`.
- Continue respecting `.gitignore`, `.ignore`, parent, global, and repository excludes.
- Do not follow symlinks.
- Infer language independently for each file unless the caller explicitly passes `lang`.
- Treat all picker input as an AST pattern, never as extra CLI arguments.
- Use `ast-grep`, then `sg`, then `/opt/homebrew/bin/ast-grep` as executable fallbacks.
- Suppress command-failure notifications for incomplete live patterns and ignore malformed/non-JSON output safely.

---

## Current repository constraints

- The worktree is already dirty. In particular, preserve existing edits in:
  - `nvim/.config/nvim/lua/nvim_keybinding_comparison.md`
  - `nvim/.config/nvim/lua/plugins/astrolsp.lua`
  - `nvim/.config/nvim/lua/plugins/conform.lua`
  - `nvim/.config/nvim/lua/plugins/comment.lua`
  - `nvim/.config/nvim/lua/plugins/indent-blankline.lua`
  - `nvim/.config/nvim/lua/plugins/yanky.lua`
- Do not modify unrelated changed/untracked files.
- `nvim/.config/nvim/lua/plugins/astrocore.lua` and `treesitter.lua` are inactive sample templates. Replace each with a minimal real spec; do not merely remove the guard because the templates contain unrelated sample settings.
- The active lockfile is runtime-local at `~/.config/nvim/lazy-lock.json`; it is not tracked by this dotfiles repository. Installing `treesitter-modules.nvim` may update that local file but must not create a tracked lockfile unless separately requested.
- Do not commit, push, or stage files.

---

### Task 1: Capture a baseline and construct executable acceptance checks

**Objective:** Prove the requested mappings are absent/conflicting before editing and create repeatable RED/GREEN checks.

**Files:**
- Modify: none

**Step 1: Record the current state**

Run:

```bash
git status --short --branch
git diff --check -- nvim/.config/nvim
```

Expected: existing dirty files are visible; no new whitespace errors are introduced by this task.

**Step 2: Record current mapping ownership**

Use headless Neovim with `vim.fn.maparg(..., false, true)` for:

```text
<C-P> in n/i/x
<C-N> in n/i
<Leader>ff, <Leader>e, <Leader>o
<Leader>fm, <Leader>fM, <Leader>fA, <Leader>fS
<Tab>, <S-Tab>, ]b, [b
zM, zR, \
gr, grr, gri, gra, grn, gi
<Leader>lR, <Leader>lf
<Leader>gu, <Leader>vs
```

Expected RED evidence includes Blink owning insert `<C-N>/<C-P>`, AstroNvim owning `<Leader>ff/<Leader>e/\`, native Neovim owning `grr/gri/gra/grn`, and the new mappings being absent.

**Step 3: Define the final verification battery**

Use three independent checks after implementation:

1. Headless startup plus global map assertions.
2. Parser/LSP-backed buffer assertions for buffer-attached mappings.
3. Functional plugin checks for AST-grep, Blink merged options, Auto Session, UFO, and Treesitter Modules.

Do not count timeouts/setup failures as PASS or FAIL; fix/re-run them.

---

### Task 2: Synchronize the comparison document with the final decisions

**Objective:** Make the comparison document an accurate source of truth rather than leaving interview questions or stale `+a` notes.

**Files:**
- Modify: `nvim/.config/nvim/lua/nvim_keybinding_comparison.md`

**Step 1: Preserve unrelated document edits**

Read the current on-disk file immediately before patching. Use targeted patches only; do not regenerate or reformat the entire table.

**Step 2: Resolve mapping rows**

Update the relevant key/mode and Note cells to record:

- Export: `<Leader>vs`, not `<Leader>cd`.
- Files: `n/i/x: <C-P>`; `<Leader>ff` disabled.
- AST-grep: `<Leader>fA` with Snacks + ast-grep.
- Manual pages: `<Leader>fM`.
- Sessions: `<Leader>fS`.
- Explorer: `n/i: <C-N>`; `<Leader>e` and `<Leader>o` disabled.
- Glance and removal choices exactly as listed under Confirmed behavior.
- Conform/UFO decisions.
- Blink replacements.
- Loops stay `ao/io`.
- Incremental selection uses `\`, `\`, `false`, and `<BS>`.
- Textsubjects mappings are intentionally unavailable because the plugin is disabled for Treesitter-main incompatibility.
- Buffer navigation and plugin-management removals.

**Step 3: Remove stale question prose**

Remove phrases such as “what mapping to use?”, “let’s think”, and “which one is better?” only where the interview settled them. Preserve purely informative conflict notes elsewhere.

**Step 4: Validate the markdown diff**

Run:

```bash
git diff --check -- nvim/.config/nvim/lua/nvim_keybinding_comparison.md
```

Expected: exit 0.

---

### Task 3: Replace the AstroCore template with minimal global mappings

**Objective:** Make AstroCore the deterministic owner of general mappings and removal decisions.

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/astrocore.lua`

**Step 1: Replace—not activate—the sample template**

The final file must contain only an `AstroNvim/astrocore` spec, the mapping callbacks/tables required here, and a small `init` hook for deleting Neovim 0.11 native LSP defaults. Do not retain sample feature flags, fake `fooscript` filetypes, or unrelated options.

**Step 2: Add reusable callbacks**

Create local callbacks for:

- Snacks Find files, using the same hidden-file behavior as AstroNvim’s original `<Leader>ff` callback.
- Neo-tree toggle.
- AstroCore next/previous buffer navigation.

Use the callbacks from each requested mode rather than duplicating bodies.

**Step 3: Add normal-mode mappings**

Add:

```text
zt -> zt3<C-Y>
<C-P> -> Find files
<C-N> -> Neotree toggle
<Leader>fA -> Snacks.picker.ast_grep()
<Leader>fM -> Snacks.picker.man()
<Tab> -> astrocore.buffer.nav(vim.v.count1)
<S-Tab> -> astrocore.buffer.nav(-vim.v.count1)
```

**Step 4: Add insert/visual mappings**

- Insert: `<C-P>` Find files, `<C-N>` Neo-tree.
- Visual: `<C-P>` Find files, `zt` context-scroll behavior.

Use AstroCore mode tables `i` and `x` so the mapping descriptions appear correctly.

**Step 5: Disable AstroNvim mappings through merged `false` values**

Set the confirmed global defaults to `false`, including:

```text
<Leader>w, <C-S>, <Leader>q, <Leader>Q, <C-Q>, <Leader>n
<Leader>ff, <Leader>fm
<Leader>e, <Leader>o
]b, [b, \
<Leader>pi, <Leader>ps, <Leader>pS, <Leader>pu, <Leader>pU
<Leader>pm, <Leader>pM, <Leader>pa
```

AstroCore’s `set_mappings()` skips false values. This prevents AstroNvim from installing `<Leader>fm` while leaving Lazy’s Conform key placeholder intact.

**Step 6: Delete Neovim 0.11 native `gr*` defaults**

In the spec’s `init` hook, use guarded `vim.keymap.del` calls to delete global:

- Normal: `grr`, `gri`, `gra`, `grn`.
- Visual: `gra`.

These are Neovim global defaults (`maparg().buffer == 0`), not AstroLSP table entries. Deleting them is required so `gr` has no longer-prefix timeout and so the replacement-only decision is real.

**Step 7: Run the focused startup test**

Run headless Neovim and assert:

- New global maps exist in every requested mode.
- Disabled AstroNvim maps are absent.
- Native `grr/gri/gra/grn` are absent.
- `<Leader>fm` still exists as a Lazy-managed Conform key with description `Format buffer`.

---

### Task 4: Add the current Snacks AST-grep source and repair the dashboard

**Objective:** Restore project-wide structural search without Telescope and keep dashboard Find files working after `<Leader>ff` removal.

**Files:**
- Create: `nvim/.config/nvim/lua/plugins/snacks.lua`

**Step 1: Register a custom `ast_grep` picker source**

Add a `folke/snacks.nvim` opts mutator that installs `opts.picker.sources.ast_grep` with:

```lua
{
  title = "AST Grep",
  format = "file",
  show_empty = true,
  live = true,
  supports_live = true,
  hidden = true,
  ignored = false,
  follow = false,
}
```

**Step 2: Implement the finder against installed Snacks 2.31**

The finder must:

1. Read the whole pattern from `ctx.filter.search` and return `{}` for blank input.
2. Resolve cwd from `opts.cwd`, then `Snacks.git.get_root(original_buffer_path)`, then `ctx:cwd()`.
3. Resolve the executable as `ast-grep`, `sg`, then `/opt/homebrew/bin/ast-grep`.
4. Build only this read-only command shape:

```text
ast-grep run --color=never --json=stream --pattern=<whole input> [--lang LANG] [ignore flags] .
```

5. Add `--no-ignore=hidden` when `hidden=true`.
6. Add all five `--no-ignore` kinds (`dot`, `exclude`, `global`, `parent`, `vcs`) only when `ignored=true`.
7. Add `--follow` only when requested.
8. Invoke the installed current API:

```lua
require("snacks.picker.source.proc").proc(ctx:opts({
  cmd = cmd,
  args = args,
  cwd = cwd,
  notify = false,
  transform = transform,
}), ctx)
```

Do not copy the older discussion’s nested proc options shape; it fails under Snacks 2.31.

**Step 3: Transform streamed JSON defensively**

Use `pcall(vim.json.decode, item.text)`. Reject malformed entries. For valid entries:

- Set `item.cwd` and `item.file`.
- Convert only zero-based row to one-based; keep byte column unchanged.
- Set `item.pos`, optional `item.end_pos`, `item.lang`, and a one-line display preview.
- Add `…` for multiline matched text.
- Construct searchable `item.text` from file, row, column, and preview.

**Step 4: Repair dashboard Find files**

Mutate the existing dashboard preset’s `f` entry so its action invokes `<C-P>` or directly calls the same Find-files picker. Do not leave it pointing at disabled `<Leader>ff`.

**Step 5: Verify the source headlessly**

Against the Neovim config, search `require($A)` and assert:

- Finder completes.
- At least one result exists.
- First valid item has file, 1-based row, byte column, cwd, and language.
- Empty/incomplete input does not throw or notify.

---

### Task 5: Replace Blink completion keys

**Objective:** Free insert `<C-P>/<C-N>` for global navigation while retaining Blink navigation on `<C-J>/<C-K>`.

**Files:**
- Create: `nvim/.config/nvim/lua/plugins/blink.lua`

**Step 1: Mutate Blink’s merged keymap**

Set:

```lua
opts.keymap["<A-Space>"] = { "show", "show_documentation", "hide_documentation" }
opts.keymap["<C-Space>"] = false
opts.keymap["<C-N>"] = false
opts.keymap["<C-P>"] = false
```

Do not change `<C-J>`, `<C-K>`, `<Tab>`, or `<S-Tab>` in Blink’s insert/cmdline keymap.

**Step 2: Assert the final merged options**

Use `require("astrocore").plugin_opts("blink.cmp").keymap` in a headless run. Expected: the three old keys are false, `<A-Space>` has the exact action chain, and `<C-J>/<C-K>` remain defined.

---

### Task 6: Configure LSP-attached Glance mappings and removals

**Objective:** Use Glance for location navigation while preserving AstroLSP capability gating and existing unrelated customizations.

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/astrolsp.lua`

**Step 1: Preserve the existing dirty-file content**

Patch only the existing `opts.mappings` section. Preserve formatting settings, server handlers, codelens, semantic tokens, and all unrelated edits.

**Step 2: Add/replace capability-gated mappings**

Configure:

```text
gd -> <Cmd>Glance definitions<CR>       textDocument/definition
gy -> <Cmd>Glance type_definitions<CR>  textDocument/typeDefinition
gr -> <Cmd>Glance references<CR>        textDocument/references
gi -> <Cmd>Glance implementations<CR>   textDocument/implementation
```

The existing `cmd = { "Glance" }` in `plugins/glance.lua` must remain the lazy-load trigger.

**Step 3: Keep selected AstroLSP mappings**

Keep `<Leader>la` in normal/visual mode and `<Leader>lr` in normal mode. Their existing capability conditions are correct.

**Step 4: Disable AstroLSP aliases**

Set:

```text
n: <Leader>lR = false
n: <Leader>lf = false
x/v: <Leader>lf = false
```

Native `gr*` removals are owned by AstroCore Task 3, not duplicated here.

**Step 5: Verify in an attached Lua LSP buffer**

Wait for `LspAttach`, then assert that `gd/gy/gr/gi` are buffer-local Glance mappings, `<Leader>lR/<Leader>lf` are absent, and `<Leader>la/<Leader>lr` remain.

---

### Task 7: Add plugin-owned keys without breaking lazy loading

**Objective:** Add keys that must load or attach through their owning plugins.

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/conform.lua`
- Modify: `nvim/.config/nvim/lua/plugins/auto-session.lua`
- Modify: `nvim/.config/nvim/lua/plugins/ufo.lua`
- Modify: `nvim/.config/nvim/lua/plugins/export-vscode.lua`
- Modify: `nvim/.config/nvim/lua/plugins/gitsigns.lua`

**Step 1: Preserve Conform’s existing mapping and formatting config**

Keep `<Leader>fm`, its `mode = ""`, async formatting, and `lsp_format = "fallback"`. Do not narrow modes or alter formatter choices. AstroCore’s false override for its own `<Leader>fm` mapping lets this Lazy key own the key from startup.

**Step 2: Add Auto Session search**

- Add `<Leader>fS` as a Lazy key calling `require("auto-session").search()`.
- Ensure Auto Session uses `session_lens.picker = "snacks"`.
- Include the current `AutoSession` command spelling in the `cmd` list without removing existing supported aliases unless confirmed obsolete.
- Preserve all session save/restore settings and pre-save commands.

**Step 3: Add UFO fold mappings**

Add Lazy keys:

```lua
zM -> require("ufo").closeAllFolds()
zR -> require("ufo").openAllFolds()
```

Keep `foldlevel`, `foldlevelstart`, `foldenable`, and UFO setup unchanged.

**Step 4: Add VS Code export**

Add `n: <Leader>vs` in the export plugin spec, calling `require("export-to-vscode").launch()`. Do not restore `<Leader>cd`.

**Step 5: Wrap Gitsigns `on_attach` safely**

Preserve any upstream `opts.on_attach`, call it first, then add buffer-local:

```text
<Leader>gu -> require("gitsigns").undo_stage_hunk
```

Preserve all current signs/blame options in the already customized `gitsigns.lua`.

**Step 6: Verify Lazy ownership**

At startup, inspect `maparg()` descriptions for `<Leader>fm`, `<Leader>fS`, `zM`, `zR`, and `<Leader>vs`. In a Git-backed buffer, verify `<Leader>gu` is buffer-local after Gitsigns attaches.

Do not invoke `<Leader>vs` during automated validation because it launches an external application; validate its callback/owner and reserve one manual invocation for explicit execution approval.

---

### Task 8: Restore incremental selection and record textsubjects as disabled

**Objective:** Reproduce the old incremental-selection behavior on Treesitter `main` without installing incompatible textsubjects.

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/treesitter.lua`
- Modify: `nvim/.config/nvim/lua/plugins/disabled.lua`
- Runtime-only effect: `~/.config/nvim/lazy-lock.json`

**Step 1: Replace the inactive Treesitter sample template**

Create a minimal spec for:

```lua
{
  "MeanderingProgrammer/treesitter-modules.nvim",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "\\",
        node_incremental = "\\",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  },
}
```

Do not add old `require("nvim-treesitter.configs")`; that API does not exist in the installed Treesitter rewrite.

**Step 2: Add the disabled textsubjects tombstone**

Append to `plugins/disabled.lua`:

```lua
-- Disabled: incompatible with nvim-treesitter's main branch.
-- Revisit after https://github.com/RRethy/nvim-treesitter-textsubjects/issues/52
{ "RRethy/nvim-treesitter-textsubjects", enabled = false },
```

Do not install, pin, or configure textsubjects. Keep `.`, `;`, `i;`, and its default repeat key `,` untouched.

**Step 3: Install only the missing maintained plugin**

Run a targeted Lazy install for `treesitter-modules.nvim`, not a blanket update/sync. Confirm it appears in `~/.config/nvim/lazy-lock.json`; do not add that runtime lockfile to the dotfiles repository.

**Step 4: Verify mappings in a parser-backed Lua buffer**

Assert:

- Normal `\` initializes a visual node selection.
- Visual `\` expands it.
- Visual `<BS>` shrinks it.
- `grc` is not added.
- `ao/io` remain the existing loop textobjects.
- `al/il` are not added, preserving Targets’ `l` modifier.

---

### Task 9: Run static and health validation

**Objective:** Catch configuration, syntax, and ownership errors before functional testing.

**Files:**
- Modify: none unless a test reveals an implementation defect

**Step 1: Check the repository diff**

Run:

```bash
git diff --check -- nvim/.config/nvim
git status --short
```

Expected: only intended Neovim files plus pre-existing changes; no whitespace errors.

**Step 2: Run startup smoke test**

Run:

```bash
nvim --headless --cmd 'set shada=' \
  -c 'lua print("startup-ok")' \
  -c 'qa!'
```

Expected: `startup-ok`, exit 0, no Lua stacktrace.

**Step 3: Run health checks**

Run headless or in a disposable Neovim instance:

```vim
:checkhealth astrocore
:checkhealth astrolsp
:checkhealth nvim-treesitter
```

Review new failures only; do not refactor unrelated health warnings.

**Step 4: Inspect final mapping sources**

Use `:verbose map`/`maparg()` for every key in Confirmed behavior. Verify exact modes, descriptions, global/buffer ownership, and absence of replaced aliases.

---

### Task 10: Run functional verification and reproducibility repeats

**Objective:** Prove the mappings execute the intended features, not merely that table entries exist.

**Files:**
- Modify: none unless a test reveals an implementation defect

**Step 1: Functional test battery A — global and Lazy-owned keys**

Verify:

- `<C-P>` opens Snacks files from Normal, Insert, and Visual modes.
- `<C-N>` toggles Neo-tree from Normal and Insert modes.
- `<Leader>fM`, `<Leader>fS`, `<Leader>fm`, `zM`, and `zR` load and call the correct owner.
- `<Tab>/<S-Tab>` navigate buffers.
- Disabled mappings do nothing and do not appear in WhichKey.

**Step 2: Functional test battery B — LSP/Git/Treesitter**

In appropriate buffers verify:

- `gd/gy/gr/gi` use Glance.
- `<Leader>la/<Leader>lr` remain functional.
- No native longer `gr*` mapping remains, so `gr` does not wait for `timeoutlen`.
- `<Leader>gu` calls Gitsigns undo-stage-hunk.
- `\`/`<BS>` perform incremental selection.
- `ao/io` still select loop objects.

**Step 3: Functional test battery C — AST-grep robustness**

Open a Lua file and use `<Leader>fA`:

1. Search `require($A)`; preview and Enter must jump to the exact match.
2. Search a multiline function pattern; each result must occupy one row and show `…`.
3. Enter empty and incomplete patterns; there must be no stacktrace or notification spam.
4. Confirm hidden `.config` files are searched while ignored files remain excluded.
5. Confirm fixed-language invocation `Snacks.picker.ast_grep({ lang = "lua" })` works.

**Step 4: Validate Alacritty key transmission**

In the user’s actual Alacritty session verify that `<A-Space>` reaches Neovim and opens Blink rather than arriving as Escape+Space or NBSP. Also verify `<C-P>`, `<C-N>`, `<Tab>`, and `<S-Tab>` in their requested modes.

**Step 5: Reproducibility gate**

After all defects are fixed and the battery first converges to PASS:

- Run the complete A+B+C battery again: must PASS.
- Run the complete A+B+C battery a second time: must PASS.

Only report WORKS after both post-convergence repeats pass. If either repeat fails, the result is **NOT REPRODUCIBLE — do not trust** until corrected and the two-repeat gate restarts.

---

## Files likely to change

### Existing project files

- `nvim/.config/nvim/lua/nvim_keybinding_comparison.md`
- `nvim/.config/nvim/lua/plugins/astrocore.lua`
- `nvim/.config/nvim/lua/plugins/astrolsp.lua`
- `nvim/.config/nvim/lua/plugins/auto-session.lua`
- `nvim/.config/nvim/lua/plugins/conform.lua`
- `nvim/.config/nvim/lua/plugins/disabled.lua`
- `nvim/.config/nvim/lua/plugins/export-vscode.lua`
- `nvim/.config/nvim/lua/plugins/gitsigns.lua`
- `nvim/.config/nvim/lua/plugins/treesitter.lua`
- `nvim/.config/nvim/lua/plugins/ufo.lua`

### New project files

- `nvim/.config/nvim/lua/plugins/blink.lua`
- `nvim/.config/nvim/lua/plugins/snacks.lua`

### Runtime-local file

- `~/.config/nvim/lazy-lock.json` — updated only by targeted installation; not tracked in this repository.

---

## Risks and mitigations

- **Dirty worktree:** patch narrowly and re-read every dirty target before editing; never overwrite whole dirty files except the two known inactive templates (`astrocore.lua`, `treesitter.lua`).
- **Native Neovim `gr*` defaults:** AstroLSP `false` does not delete these global defaults; delete them explicitly in AstroCore init and verify no prefix remains.
- **Conform/Find-man collision:** AstroCore must set its own `<Leader>fm` entry false while Conform retains the Lazy key. AstroCore skips false entries, allowing Lazy’s placeholder to survive from startup.
- **Dashboard breakage:** disabling `<Leader>ff` requires rewriting dashboard `f` in Snacks config.
- **Snacks API drift:** use installed 2.31 proc signature, not the outdated discussion #1966 shape.
- **Live AST parse errors:** skip blank input, pass `--pattern=<value>`, set `notify=false`, and guard JSON decoding.
- **Terminal key encoding:** verify `<A-Space>` in Alacritty rather than relying only on headless mapping inspection.
- **`<Tab>` versus `<C-I>`:** accepted tradeoff; document it and do not add an unrequested replacement jump key.
- **Treesitter-main compatibility:** use `treesitter-modules.nvim`; never call removed `nvim-treesitter.configs` APIs.
- **Textsubjects:** keep an explicit disabled tombstone with upstream issue link; do not pin the unmerged PR.
- **Targets collision:** preserve `ao/io`; do not add `al/il`.

## Open questions

None. The grill interview resolved all behavior, scope, ownership, dependency, and documentation decisions. Implementation must stop and ask if repository state changes materially before execution.