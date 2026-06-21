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

==============================================================================
vim.lsp:                                     require("vim.lsp.health").check()

- LSP log level : WARN
- Log path: /Users/birudo/.local/state/nvim-test/lsp.log
- Log size: 0 KB

vim.lsp: Active Clients ~
- No active clients

vim.lsp: Enabled Configurations ~
- ⚠️ WARNING 'lua-language-server' is not executable. Configuration will not be used.
- lua_ls:
  - capabilities: {
      textDocument = {
        completion = {
          completionItem = {
            commitCharactersSupport = false,
            deprecatedSupport = true,
            documentationFormat = { "markdown", "plaintext" },
            insertReplaceSupport = true,
            insertTextModeSupport = {
              valueSet = { 1 }
            },
            labelDetailsSupport = true,
            preselectSupport = false,
            resolveSupport = {
              properties = { "documentation", "detail", "additionalTextEdits", "command", "data" }
            },
            snippetSupport = true,
            tagSupport = {
              valueSet = { 1 }
            }
          },
          completionList = {
            itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" }
          },
          contextSupport = true,
          insertTextMode = 1
        }
      },
      workspace = {
        fileOperations = {
          didCreate = true,
          didDelete = true,
          didRename = true,
          willCreate = true,
          willDelete = true,
          willRename = true
        }
      }
    }
  - cmd: { "lua-language-server" }
  - filetypes: lua
  - root_markers: .emmyrc.json, .luarc.json, .luarc.jsonc, .luacheckrc, .stylua.toml, stylua.toml, selene.toml, selene.yml, .git
  - settings: {
      Lua = {
        codeLens = {
          enable = true
        },
        hint = {
          enable = true,
          semicolon = "Disable"
        }
      }
    }


vim.lsp: File Watcher ~
- file watching "(workspace/didChangeWatchedFiles)" disabled on all clients

vim.lsp: Position Encodings ~
- No active clients

```