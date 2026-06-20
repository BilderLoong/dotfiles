# Keybinding Comparison: NvChad → AstroNvim

## Legend
- ✅ Same in both
- ⚠️ Changed (key or tool differs)
- ❌ Missing in new config
- 🆕 New (AstroNvim default)

---

## General

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `i` `jk` | Escape insert mode | — | ❌ |
| `n` `<leader>cd` | Export to VSCode | — | ❌ |
| `n` `<leader>cg` | Open nvim config | — | ❌ |
| `n/v` `zt` | Scroll top + 3 lines up | Default vim zt | ❌ |
| `n` `<leader>D` | (disabled) | — | ✅ |
| `n` `<leader>Q` | — | Exit AstroNvim | 🆕 |
| `n` `<leader>R` | — | Rename file | 🆕 |
| `n` `<leader>w` | — | Save | 🆕 |
| `n` `<leader>n` | — | New file | 🆕 |
| `n` `<leader>q` | — | Quit window | 🆕 |
| `n` `<leader>c` | — | Close buffer | 🆕 |
| `n` `<leader>C` | — | Force close buffer | 🆕 |

## Finding / Picker

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `<C-P>` | fzf-lua find files | — | ❌ |
| `n` `<leader>ff` | (default) | Find files | ✅ |
| `n` `<leader>fb` | — | Find buffers | 🆕 |
| `n` `<leader>fg` | — | Find git files | 🆕 |
| `n` `<leader>fw` | fzf-lua live grep native | Find words | ⚠️ |
| `n` `<leader>fW` | — | Find words (all files) | 🆕 |
| `n` `<leader>fo` | — | Find old files | 🆕 |
| `n` `<leader>fO` | — | Find old files (cwd) | 🆕 |
| `n` `<leader>fh` | — | Find help | 🆕 |
| `n` `<leader>fc` | — | Find word under cursor | 🆕 |
| `n` `<leader>fC` | — | Find commands | 🆕 |
| `n` `<leader>fk` | — | Find keymaps | 🆕 |
| `n` `<leader>fr` | — | Find registers | 🆕 |
| `n` `<leader>fm` | (disabled) | Find man | ⚠️ |
| `n` `<leader>fn` | — | Find notifications | 🆕 |
| `n` `<leader>ft` | — | Find themes | 🆕 |
| `n` `<leader>fp` | — | Find projects | 🆕 |
| `n` `<leader>fu` | — | Find undo history | 🆕 |
| `n` `<leader>fT` | — | Find TODOs | 🆕 |
| `n` `<leader>fl` | — | Find lines | 🆕 |
| `n` `<leader>f'` | — | Find marks | 🆕 |
| `n` `<leader>f<CR>` | — | Resume previous search | 🆕 |
| `n` `<leader>fF` | — | Find all files (hidden) | 🆕 |
| `n` `<leader>fa` | — | Find AstroNvim config | 🆕 |
| `n` `<leader>fs` | — | Find buffers/recent/files | 🆕 |
| `n` `<leader>F` | — | Find all files | 🆕 |
| `n` `<F1>` | fzf-lua help tags | — | ❌ |
| `n/i` `<A-d>` | Telescope document symbols | — | ❌ |
| `n/i` `<A-b>` | Telescope builtins | — | ❌ |
| `n/i` `<A-p>` | Telescope commands | — | ❌ |
| `n/i` `<A-r>` | Telescope resume | — | ❌ |
| `n` `<leader>sg` | Telescope ast_grep | — | ❌ |
| `n` `<leader>rr` | fzf-lua resume | — | ❌ |

## File Explorer

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `<leader>e` | NvimTree toggle | Neo-tree toggle | ⚠️ |
| `n` `<leader>o` | — | Neo-tree focus | 🆕 |

## LSP

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `gd` | Glance definitions | vim.lsp.buf.definition() | ⚠️ |
| `n` `gr` | Glance references | — | ❌ |
| `n` `gy` | Glance type definitions | — | ❌ |
| `n` `gi` | Telescope implementations | — | ❌ |
| `n` `grr` | — | vim.lsp.buf.references() | 🆕 |
| `n` `gri` | — | vim.lsp.buf.implementation() | 🆕 |
| `n` `gra` | — | vim.lsp.buf.code_action() | 🆕 |
| `n` `grn` | — | vim.lsp.buf.rename() | 🆕 |
| `n` `gO` | Lspsaga outline | vim.lsp.buf.document_symbol() | ⚠️ |
| `n` `ga` | Lspsaga finder | — | ❌ |
| `n` `K` | Lspsaga hover doc | vim.lsp.buf.hover() | ⚠️ |
| `n` `<leader>ca` | Lspsaga code action | — | ❌ |
| `n` `<leader>n` | Lspsaga diagnostic jump next | — | ❌ |
| `n` `<leader>li` | — | LSP information | 🆕 |
| `n` `<leader>ld` | — | Hover diagnostics | 🆕 |
| `n` `<leader>lD` | — | Search diagnostics | 🆕 |
| `n` `<leader>ls` | — | Search symbols | 🆕 |
| `n` `<leader>lS` | — | Symbols outline | 🆕 |
| `n` `[d` | — | Previous diagnostic | 🆕 |
| `n` `]d` | — | Next diagnostic | 🆕 |
| `n` `[D` | — | First diagnostic | 🆕 |
| `n` `]D` | — | Last diagnostic | 🆕 |

## Git

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `<leader>gg` | — | Lazygit | 🆕 |
| `n` `<leader>go` | — | Git browse (open) | 🆕 |
| `n` `<leader>gb` | — | Git branches | 🆕 |
| `n` `<leader>gc` | — | Git commits (repo) | 🆕 |
| `n` `<leader>gC` | — | Git commits (file) | 🆕 |
| `n` `<leader>gt` | fzf-lua git status | Git status | ⚠️ |
| `n` `<leader>gT` | — | Git stash | 🆕 |
| `v/n` `<leader>ghs` | Gitsigns stage hunk | — | ❌ |
| `v/n` `<leader>ghr` | Gitsigns reset hunk | — | ❌ |
| `v/n` `<leader>ghu` | Gitsigns undo stage hunk | — | ❌ |
| `x/o` `ih` | Gitsigns select hunk | — | ❌ |

## Debug (DAP)

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `<F9>` | Toggle breakpoint | Toggle breakpoint | ✅ |
| `n` `<S-F9>` | Conditional breakpoint | Conditional breakpoint | ✅ |
| `n` `<F10>` | Step over | Step over | ✅ |
| `n` `<F11>` | Step into | Step into | ✅ |
| `n` `<S-F11>` | Step out | Step out | ✅ |
| `n` `<F5>` | Continue | Continue | ✅ |
| `n` `<S-F5>` | Terminate | Terminate | ✅ |
| `n` `<Leader>dp` | DAP preview | DAP Preview | ✅ |
| `n` `<Leader>dk` | DAP hover | DAP Hover | ✅ |
| `n` `<Leader>ds` | Run to cursor | Run to cursor | ✅ |
| `n` `<Leader>du` | Toggle DAP UI | Toggle Debugger UI | ✅ |
| `n` `<Leader>dR` | — | Restart (C-F5) | 🆕 |
| `n` `<Leader>dh` | — | Debugger Hover | 🆕 |
| `n` `<Leader>dB` | — | Clear Breakpoints | 🆕 |
| `n` `<Leader>dE` | — | Evaluate Input | 🆕 |
| `n` `<Leader>dq` | — | Close Session | 🆕 |
| `n` `<Leader>dQ` | — | Terminate Session | 🆕 |
| `n` `<leader>osv` | Start lua debug server | Start lua debug server | ✅ |

## Session (auto-session)

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `<leader>ss` | Session lens (Telescope) | — | ❌ |

## Formatting

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n/v/o` `<leader>fm` | Format buffer (conform) | — | ❌ |
| `n/v` `<leader>fm` | — | Format buffer | 🆕 |

## Folds (nvim-ufo)

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `zM` | Close all folds (ufo) | Default vim zM | ❌ |
| `n` `zR` | Open all folds (ufo) | Default vim zR | ❌ |

## Haskell Tools

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `<leader>re` | Eval all snippets | — | ❌ |
| `n` `<leader>rq` | Quit GHCi repl | — | ❌ |
| `n` `<leader>rf` | Toggle GHCi repl | — | ❌ |

## Copilot

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `i` `<C-J>` | Accept suggestion | — | ❌ |

## Yanky

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `p` | Yanky put after | Default p | ❌ |
| `n` `P` | Yanky put before | Default P | ❌ |
| `n` `gp` | Yanky grand put after | Default gp | ❌ |
| `n` `gP` | Yanky grand put before | Default gP | ❌ |
| `n` `<A-k>` | Yanky previous entry | — | ❌ |
| `n` `<A-j>` | Yanky next entry | — | ❌ |

## Substitute

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `m` | Substitute operator | Substitute operator | ✅ |
| `n` `mm` | Substitute line | Substitute line | ✅ |
| `n` `M` | Substitute EOL | Substitute EOL | ✅ |
| `x` `m` | Substitute visual | Substitute visual | ✅ |
| `n` `mx` | Exchange operator | Exchange operator | ✅ |
| `n` `mxx` | Exchange line | Exchange line | ✅ |
| `x` `X` | Exchange visual | Exchange visual | ✅ |
| `n` `mxc` | Exchange cancel | Exchange cancel | ✅ |
| `n/o/x` `<leader>mm` | Default m key | Default m key | ✅ |

## Flash

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n/o/x` `s` | Flash jump | Flash jump | ✅ |
| `n/o/x` `S` | Flash treesitter | Flash treesitter | ✅ |
| `o` `r` | Remote flash | Remote flash | ✅ |
| `o/x` `R` | Treesitter search | Treesitter search | ✅ |
| `c` `<c-s>` | Toggle flash search | Toggle flash search | ✅ |

## UI Toggles (AstroNvim defaults — all new)

| Key | Action |
|-----|--------|
| `<leader>ut` | Toggle tabline |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uu` | Toggle URL highlight |
| `<leader>us` | Toggle spellcheck |
| `<leader>uw` | Toggle wrap |
| `<leader>uv` | Toggle virtual text |
| `<leader>uV` | Toggle virtual lines |
| `<leader>ua` | Toggle autopairs |
| `<leader>uC` | Toggle completion (global) |
| `<leader>uc` | Toggle completion (buffer) |
| `<leader>u|` | Toggle indent guides |
| `<leader>uA` | Toggle rooter autochdir |
| `<leader>ub` | Toggle background |
| `<leader>un` | Change line numbering |
| `<leader>u>` | Toggle foldcolumn |
| `<leader>ug` | Toggle signcolumn |
| `<leader>uz` | Toggle color highlight |
| `<leader>uN` | Toggle notifications |
| `<leader>uD` | Dismiss notifications |
| `<leader>ul` | Toggle statusline |
| `<leader>uZ` | Toggle zen mode |
| `<leader>uy` | Toggle syntax highlight |
| `<leader>ui` | Change indent setting |
| `<leader>ur` | Toggle reference highlighting |
| `<leader>up` | Toggle paste mode |
| `<leader>uS` | Toggle conceal |

## Plugin Management (all new)

| Key | Action |
|-----|--------|
| `<leader>pi` | Install plugins |
| `<leader>ps` | Plugin status |
| `<leader>pS` | Plugin sync |
| `<leader>pu` | Check updates |
| `<leader>pU` | Update plugins |
| `<leader>pm` | Mason install |
| `<leader>pM` | Mason update |
| `<leader>pa` | Update Lazy + Mason |

## Buffer Management (all new)

| Key | Action |
|-----|--------|
| `<leader>bb` | Select buffer from tabline |
| `<leader>bd` | Close buffer from tabline |
| `<leader>bl` | Close all buffers to left |
| `<leader>br` | Close all buffers to right |
| `<leader>bc` | Close all buffers except current |
| `<leader>bC` | Close all buffers |
| `<leader>b|` | Vertical split buffer from tabline |
| `<leader>b\` | Horizontal split buffer from tabline |
| `]b` | Next buffer |
| `[b` | Previous buffer |

## Terminal (all new)

| Key | Action |
|-----|--------|
| `<leader>th` | ToggleTerm horizontal split |
| `<leader>tv` | ToggleTerm vertical split |
| `<leader>tf` | ToggleTerm float |
| `<leader>tl` | ToggleTerm lazygit |
| `<leader>tn` | ToggleTerm node |
| `<leader>tp` | ToggleTerm python |
| `<leader>tu` | ToggleTerm gdu |
| `<F7>` | Toggle terminal |
| `<C-'>` | Toggle terminal |

## Splits / Navigation (all new)

| Key | Action |
|-----|--------|
| `<C-H>` | Move to left split |
| `<C-J>` | Move to below split |
| `<C-K>` | Move to above split |
| `<C-L>` | Move to right split |
| `<C-Up>` | Resize split up |
| `<C-Down>` | Resize split down |
| `<C-Left>` | Resize split left |
| `<C-Right>` | Resize split right |

## Comment

| Key | Old (NvChad) | New (AstroNvim) | Status |
|-----|-------------|-----------------|--------|
| `n` `/` | (Comment.nvim) | Toggle comment line | ✅ |
| `v` `/` | (Comment.nvim) | Toggle comment | ✅ |

## Quickfix / Location List (new)

| Key | Action |
|-----|--------|
| `<leader>xq` | Quickfix List |
| `<leader>xl` | Location List |

---

## Summary

| Category | Count |
|----------|-------|
| ✅ Same in both | ~20 |
| ⚠️ Changed | ~10 |
| ❌ Missing from new | ~25 |
| 🆕 New in AstroNvim | ~80+ |

### Key Missing Items to Restore
1. `i` `jk` → escape insert mode
2. `n` `<leader>ss` → session lens
3. `n` `gr/gy/gi/ga` → Glance/Lspsaga LSP bindings
4. `v/n` `<leader>ghs/ghr/ghu` → gitsigns hunk operations
5. `n` `<A-k>/<A-j>` → yanky history
6. `i` `<C-J>` → copilot accept
7. `n` `zM/zR` → ufo fold all
8. `n` `<leader>re/rq/rf` → haskell tools
9. `n` `<C-P>` → find files shortcut
10. `n` `<leader>ca` → code action (Lspsaga)
