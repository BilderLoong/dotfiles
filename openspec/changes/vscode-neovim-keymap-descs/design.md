## Context

The nvim-vscode config (`nvim-vscode/.config/nvim-vscode/init.lua`) defines keymaps in three ways:
1. `vim.cmd` VimScript blocks (LSP, folder, UI sections)
2. `vim.keymap.set` Lua calls (most keymaps)
3. Implicit vscode-neovim defaults from `runtime/vscode/overrides/*.vim`

Only method 2 supports the `desc` option. Methods 1 and 3 produce keymaps with no description, which are invisible in the `<Leader>?` cheatsheet.

## Goals / Non-Goals

**Goals:**
- Every keymap in the config has an explicit `desc` string
- All vscode-neovim defaults the user relies on are overridden with explicit `desc`
- The `<Leader>?` cheatsheet shows a complete, categorized list of all active keymaps

**Non-Goals:**
- Changing any keymap behavior or key bindings
- Adding new keymaps beyond the vscode-neovim default overrides
- Modifying treesitter `incremental_selection` keymaps (plugin limitation)
- Removing or replacing any existing functionality

## Decisions

### Decision 1: Convert `vim.cmd` to Lua instead of wrapping

**Choice**: Rewrite all `vim.cmd` keymap blocks as native `vim.keymap.set` calls with `desc`.

**Why**: Converting to Lua is cleaner than trying to add `desc` to VimScript. It also makes the config consistent — all keymaps use the same API.

**Alternatives considered**:
- Keep `vim.cmd` and add `desc` via separate `vim.keymap.set` calls: rejected — duplicates mappings, confusing.

### Decision 2: Override vscode-neovim defaults explicitly

**Choice**: Add a new `vscode_overrides()` function that re-declares all vscode-neovim default keybindings from `runtime/vscode/overrides/` using `vim.keymap.set` with `desc`.

**Why**: vscode-neovim's VimScript defaults can't have `desc` added from user config. Overriding them with `vim.keymap.set` makes them visible in the cheatsheet. Since user Lua runs after extension VimScript, the override is natural.

**Alternatives considered**:
- Leave defaults as-is (invisible in cheatsheet): rejected per user preference.
- File a PR to vscode-neovim to add `desc`: good long-term fix but out of scope now.

### Decision 3: Selective window command overrides

**Choice**: Override the most useful `<C-w>` window commands (splits, close, navigate, resize, move) but skip rarely-used variants (arrow key variants, `<C-w><C-Down>` etc.).

**Why**: The full list is ~40 keymaps. Many are duplicates (arrow keys vs hjkl). Overriding the primary variants covers the user's needs without excessive noise.

### Decision 4: Treesitter keymaps left as-is

**Choice**: Do not modify `incremental_selection` keymaps.

**Why**: nvim-treesitter's config only accepts plain strings for these keymaps, not the `{ key, opts }` table format. Attempting to override them would require reaching into internal plugin APIs.

## Risks / Trade-offs

- **[Override drift]** → If vscode-neovim adds new defaults in future versions, they won't have `desc`. Mitigation: users can add overrides as needed.
- **[Override conflict]** → Some overrides may behave slightly differently from VimScript originals (e.g., count support for `gt`). Mitigation: implement count support for keymaps that need it.
- **[File size]** → Adding ~53 override keymaps increases init.lua by ~80 lines. Acceptable trade-off for discoverability.
