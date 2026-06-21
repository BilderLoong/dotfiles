# NVIM CONTROL & DEBUGGING GUIDE

All documentation: `:help remote` in nvim, or `nvim --help`.

## Methods

| # | Method | Command | Pros | Cons | Best For |
|---|--------|---------|------|------|----------|
| 1 | Headless | `nvim --headless -c 'lua ...' -c 'quitall'` | No setup, disposable | Timing issues, no UI | Installs, one-shot tasks |
| 2 | Remote Expr | `nvim --server <s> --remote-expr 'expr'` | Live instance, stdout result | Need socket path | **Debugging** |
| 3 | Remote Send | `nvim --server <s> --remote-send '<keys>'` | Simulates keypresses | No return value | Testing keybindings |
| 4 | Remote Open | `nvim --server <s> --remote <file>` | Simple, non-intrusive | Only opens files | Opening files |
| 5 | Embed | `nvim --embed --headless` | Full bidirectional | Complex (msgpack) | Building tools |
| 6 | Listen | `nvim --listen <addr>` | Persistent server | Lifecycle mgmt | Long integrations |
| 7 | Remote UI | `nvim --server <s> --remote-ui` | Exact user view | Interactive only | Seeing user's screen |

## Quick Reference

```bash
# Find running nvim sockets
ls /tmp/nvim-*/0 2>/dev/null || ls $TMPDIR/nvim.*/*/nvim.*.0 2>/dev/null

# Query live state (no timing issues)
nvim --server <socket> --remote-expr 'luaeval("vim.inspect(vim.lsp.get_clients())")'
nvim --server <socket> --remote-expr 'luaeval("vim.inspect(vim.lsp._enabled_configs)")'
nvim --server <socket> --remote-expr '&filetype'

# Send commands
nvim --server <socket> --remote-send '<CMD>LspInfo<CR>'

# Fix LSP race condition (re-trigger FileType)
nvim --server <socket> --remote-expr 'luaeval("vim.api.nvim_exec_autocmds(\"FileType\", {buffer=0})")'
```

## Known Bug: LSP Race Condition (AstroNvim Upstream)

**Confirmed on fresh AstroNvim** — not our config.

**Root cause:** mason-lspconfig bridge runs `vim.lsp.enable()` inside 3 nested `vim.schedule` calls. By the time it executes, the `FileType` event for the current buffer has already fired and won't fire again.

**Symptom:** Server appears in `vim.lsp._enabled_configs` but NOT in `vim.lsp.get_clients()`.

**Fix:** Re-trigger FileType autocmd after bridge completes:
```lua
vim.api.nvim_exec_autocmds("FileType", { buffer = 0 })
```
