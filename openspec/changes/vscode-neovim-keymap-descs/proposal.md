## Why

The nvim-vscode config has ~30 keymaps defined via `vim.cmd` VimScript blocks or `vim.keymap.set` calls without `desc`. This means they don't appear in the `<Leader>?` keymap cheatsheet, making them invisible and hard to discover. Additionally, vscode-neovim ships ~53 default keybindings (defined in `runtime/vscode/overrides/`) that also lack `desc` and won't appear in the cheatsheet. Users have no single place to see all active keymaps.

## What Changes

- Convert all `vim.cmd` VimScript blocks to Lua `vim.keymap.set` calls with `desc`
- Add `desc` to all existing `vim.keymap.set` calls that are missing it
- Add a new `vscode_overrides()` function that explicitly overrides ALL vscode-neovim default keybindings from `runtime/vscode/overrides/` with `desc`
- Exception: treesitter `incremental_selection` keymaps left as-is (plugin doesn't support `desc` format)

## Capabilities

### New Capabilities
- `keymap-desc-coverage`: All user-defined and overridden keymaps have explicit `desc` and appear in the `<Leader>?` cheatsheet

### Modified Capabilities

## Impact

- Single file: `nvim-vscode/.config/nvim-vscode/init.lua`
- No new dependencies
- No breaking changes to keymap behavior — same keys, same actions, just adding metadata
- The `<Leader>?` cheatsheet will now show ~77 additional keymaps with descriptions
