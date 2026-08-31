# VS Code-Style Git Log Preview Implementation Plan

> **For Hermes:** Use systematic debugging and execute this plan only after the user explicitly approves the temporary preview result. Do not change mappings, commands, or unrelated UI.

**Goal:** Make the existing `<Leader>gC` Snacks Git Log preview resemble the supplied VS Code diff while preserving its current keybinding and picker behavior.

**Architecture:** Keep the Snacks Git Log picker and replace only its diff-rendering backend. First test Snacks' supported `terminal` preview mode with the already-installed `delta` renderer in a temporary Neovim process; persist the change only after the user sees and approves that real render. Remove the earlier highlight experiments only after the replacement is accepted.

**Tech Stack:** Neovim 0.12.5, AstroNvim 6, `snacks.nvim`, git-delta 0.18.2, tmux terminal capture.

---

## Current evidence and root cause

1. `<Leader>gC` is currently and must remain `Git commits (current file)`.
2. The latest terminal test proves Snacks receives the configured RGB values. This is not a stale-config or true-color problem.
3. Snacks' fancy renderer selects one group per line in `snacks.nvim/lua/snacks/picker/util/diff.lua:338-449`:
   - `SnacksDiffAdd`
   - `SnacksDiffDelete`
   - `SnacksDiffContext`
4. The supplied VS Code target is structurally different: old/new sides plus stronger changed-text regions. Repeatedly changing two line colors cannot reproduce that structure.
5. Snacks supports an external terminal diff renderer through `previewers.diff.style = "terminal"` (`snacks.nvim/lua/snacks/picker/preview.lua:196-253`).
6. `/opt/homebrew/bin/delta` version 0.18.2 is installed. `git/.gitconfig:21-24` already enables dark, side-by-side delta output.

## Scope guardrails

- Do not change `<Leader>gC` or any other mapping.
- Do not change the Git Log source, commit list, or selection behavior.
- Do not change global `.gitconfig` during this task.
- Do not change picker width/layout unless the user separately approves it.
- Do not commit or push.
- Do not make a permanent edit until the temporary delta preview is shown to and approved by the user.

## Acceptance criteria

- `<Leader>gC` still opens `Git commits (current file)`.
- The commit list remains on the left and behaves exactly as before.
- The preview uses delta's old/new presentation, syntax colors, and word-level emphasis.
- No reverse-video token boxes appear.
- Context is readable and added/deleted sections are visually distinct.
- The result is verified twice in fresh Neovim processes after the first successful run.

---

### Task 1: Capture a deterministic baseline

**Objective:** Preserve evidence of the current fancy-renderer output before testing alternatives.

**Files:** None.

**Steps:**

1. Launch a temporary 160×50 tmux session in `/Users/birudo/Projects/yomitan_word_audio_source`.
2. Open `src/lib.rs` in a fresh Neovim process.
3. Trigger the current `<Leader>gC` mapping.
4. Wait for actual diff text, not merely the picker frame.
5. Capture the final pane with ANSI colors.
6. Record:
   - mapping description,
   - renderer mode,
   - line background RGB values,
   - whether word-level highlights exist.
7. Destroy the temporary tmux session.

**Expected result:** Baseline confirms the picker is using Snacks `fancy` rendering and only line-level add/delete groups.

---

### Task 2: Test delta without editing the dotfiles

**Objective:** Prove whether delta produces the requested visual structure inside the same picker.

**Files:** None; runtime-only experiment.

**Steps:**

1. Launch a second temporary Neovim process with the normal configuration.
2. Invoke the current-file Git Log picker with a per-invocation override equivalent to:

```lua
require("snacks").picker.git_log({
  current_file = true,
  follow = true,
  previewers = {
    diff = { style = "terminal" },
  },
})
```

3. Do not add this code to any repository file.
4. Wait until delta has rendered the selected commit.
5. Capture the final ANSI pane and a screenshot.
6. Confirm:
   - the commit list still works,
   - delta is the process rendering the preview,
   - old/new regions and word-level changes are visible,
   - syntax colors remain readable,
   - no reverse-video patchwork remains.
7. Destroy the temporary session.

**Expected result:** The existing Git Log picker remains, but its preview resembles the VS Code target more closely than the fancy renderer.

---

### Task 3: User approval gate

**Objective:** Prevent another permanent guess.

**Files:** None.

**Steps:**

1. Show the user the baseline and temporary delta result side by side.
2. Ask for one explicit decision:
   - accept delta preview as shown;
   - reject it and keep the current renderer;
   - if side-by-side is too narrow, choose between unified delta output or a separately approved wider preview.
3. Stop without editing if the user rejects the temporary result.

**Expected result:** The exact visual result is approved before persistence.

---

### Task 4: Persist the minimal renderer change

**Objective:** Save only the approved preview backend.

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/snacks.lua:118-128`

**Proposed change:** Extend the existing picker options without changing mappings:

```lua
opts.picker.previewers = opts.picker.previewers or {}
opts.picker.previewers.diff = vim.tbl_deep_extend("force", opts.picker.previewers.diff or {}, {
  style = "terminal",
})
```

Do not set another `cmd`: Snacks already defaults to `{ "delta" }`, and delta is installed.

**Expected result:** Fresh Neovim instances use delta for Git Log diff previews.

---

### Task 5: Remove superseded color experiments

**Objective:** Restore a lean configuration after delta takes ownership of preview colors.

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/astroui.lua:30-44`
- Modify: `nvim/.config/nvim/lua/plugins/diffview.lua:1-44`

**Steps:**

1. Remove only the diff highlight groups introduced during this failed experiment from `astroui.lua`.
2. Restore `diffview.lua` to its previous plugin specification with only `enhanced_diff_hl = true`.
3. Preserve the pre-existing comment highlights and every unrelated option.
4. Confirm no changes in:
   - `nvim/.config/nvim/lua/plugins/astrocore.lua`
   - `nvim/.config/nvim/lua/nvim_keybindings.md`

**Expected result:** No dead experimental highlight configuration remains, and Diffview returns to its original behavior.

---

### Task 6: Verify behavior and rendering

**Objective:** Prove both appearance and non-regression.

**Files:** None.

**Steps:**

1. Start a fresh Neovim process in a Git repository.
2. Assert with `maparg()` that `<Leader>gC` still describes `Git commits (current file)`.
3. Open the picker and wait for delta-rendered diff text.
4. Capture terminal ANSI output and confirm true-color output is present.
5. Navigate between at least two commits and confirm the preview refreshes.
6. Close and reopen the picker once.
7. Repeat the complete successful test in two additional fresh Neovim processes.
8. Run `git diff --check`.
9. Ask the user to visually confirm one final Alacritty screenshot.

**Expected result:** Three successful runs total, including two confirmation runs, with unchanged mappings and approved preview appearance.

## Risks and decision points

- **Preview width:** Delta side-by-side output may be cramped in the current preview pane. Do not widen the picker automatically; ask before changing layout.
- **Global delta settings:** The existing `.gitconfig` enables side-by-side globally. If picker-specific behavior is needed, pass Git `-c` arguments through Snacks rather than editing `.gitconfig`.
- **Terminal preview tradeoff:** Delta owns syntax and diff colors in terminal mode; Neovim highlight groups no longer style those lines. This is intentional and avoids the failed group-combination problem.
- **Fallback:** If terminal delta is rejected, return to diagnosis. Do not try another palette without first rendering candidate swatches in a temporary Neovim session.

## Files likely to change after approval

```text
nvim/.config/nvim/lua/plugins/snacks.lua     # one renderer option
nvim/.config/nvim/lua/plugins/astroui.lua    # remove failed experiment only
nvim/.config/nvim/lua/plugins/diffview.lua   # restore original config only
```

No keybinding or keybinding-documentation file should change.
