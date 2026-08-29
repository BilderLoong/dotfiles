# Neovim keybinding reference

Last verified: 2026-08-29

## Scope and notation

- Environment: Neovim 0.12.5 with AstroNvim 6.
- `<Leader>` is `<Space>`.
- This reference covers every described global mapping reported by Neovim, real Lua-buffer mappings from LSP, Gitsigns, Treesitter, Aerial, and Autopairs, plus mappings managed internally by Blink, Better Escape, and nvim-surround.
- Buffer-local mappings appear only when the matching language server, parser, Git integration, or file type is active.
- Plugin-internal UI mappings (for example inside Snacks pickers, Neo-tree, Lazy, Mason, or DAP UI) are intentionally excluded; press `?` inside those interfaces for their local help.
- Native Vim commands without an explicit mapping are outside this reference.

### Mode legend

| Mode | Meaning |
| --- | --- |
| `n` | Normal |
| `i` | Insert |
| `x` | Visual |
| `s` | Select |
| `o` | Operator-pending |
| `t` | Terminal |
| `c` | Command-line |

## Quick reference

| Key | Mode | Action |
| --- | --- | --- |
| `<C-P>` | `n/i/x` | Find files |
| `<C-N>` | `n/i` | Toggle Neo-tree |
| `<Tab>` / `<S-Tab>` | `n` | Next / previous buffer |
| `<Leader>fA` | `n` | Find AST patterns |
| `<Leader>fS` | `n` | Search saved sessions |
| `gd` / `gy` / `gr` / `gi` | `n` | Definitions / type definitions / references / implementations in Glance |
| `<Leader>la` | `n/x` | LSP code action |
| `<Leader>lr` | `n` | Rename symbol |
| `<Leader>fm` | `n/x/s/o` | Format with Conform |
| `\` / `<BS>` | `n/x` | Start or grow / shrink Treesitter selection |
| `<Leader>gs` / `<Leader>gr` / `<Leader>gu` | `n/x/s` | Stage / reset / undo-stage Git hunk |
| `zM` / `zR` | `n` | Close / open all folds |
| `<A-Space>` | `i` | Open completion and documentation |
| `<C-J>` / `<C-K>` | `i` | Next / previous completion item |
| `gcc` / `gc` | `n` / `x/o` | Toggle line / selection or motion comment |

## Leader mappings

### Core and miscellaneous

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>c` | `n` | Close buffer | Global |
| `<Leader>C` | `n` | Force close buffer | Global |
| `<Leader>h` | `n` | Home Screen | Global |
| `<Leader>mm` | `n/x/o` | Default m key. | Global |
| `<Leader>R` | `n` | Rename file | Global |
| `<Leader>vs` | `n` | Export project to VS Code | Global |

### Buffers

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>b\` | `n` | Horizontal split buffer from tabline | Global |
| `<Leader>bb` | `n` | Select buffer from tabline | Global |
| `<Leader>bC` | `n` | Close all buffers | Global |
| `<Leader>bc` | `n` | Close all buffers except current | Global |
| `<Leader>bd` | `n` | Close buffer from tabline | Global |
| `<Leader>bl` | `n` | Close all buffers to the left | Global |
| `<Leader>bp` | `n` | Previous buffer | Global |
| `<Leader>br` | `n` | Close all buffers to the right | Global |
| `<Leader>bse` | `n` | By extension | Global |
| `<Leader>bsi` | `n` | By buffer number | Global |
| `<Leader>bsm` | `n` | By modification | Global |
| `<Leader>bsp` | `n` | By full path | Global |
| `<Leader>bsr` | `n` | By relative path | Global |
| `<Leader>b\|` | `n` | Vertical split buffer from tabline | Global |

### Finding, formatting, and sessions

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>f'` | `n` | Find marks | Global |
| `<Leader>f<CR>` | `n` | Resume previous search | Global |
| `<Leader>fA` | `n` | Find AST patterns | Global |
| `<Leader>fa` | `n` | Find AstroNvim config files | Global |
| `<Leader>fb` | `n` | Find buffers | Global |
| `<Leader>fC` | `n` | Find commands | Global |
| `<Leader>fc` | `n` | Find word under cursor | Global |
| `<Leader>fF` | `n` | Find all files | Global |
| `<Leader>fg` | `n` | Find git files | Global |
| `<Leader>fh` | `n` | Find help | Global |
| `<Leader>fk` | `n` | Find keymaps | Global |
| `<Leader>fl` | `n` | Find lines | Global |
| `<Leader>fM` | `n` | Find man | Global |
| `<Leader>fm` | `n/x/s/o` | Format buffer | Global |
| `<Leader>fn` | `n` | Find notifications | Global |
| `<Leader>fo` | `n` | Find old files | Global |
| `<Leader>fO` | `n` | Find old files (cwd) | Global |
| `<Leader>fp` | `n` | Find projects | Global |
| `<Leader>fr` | `n` | Find registers | Global |
| `<Leader>fs` | `n` | Find buffers/recent/files | Global |
| `<Leader>fS` | `n` | Search sessions | Global |
| `<Leader>fT` | `n` | Find TODOs | Global |
| `<Leader>ft` | `n` | Find themes | Global |
| `<Leader>fu` | `n` | Find undo history | Global |
| `<Leader>fw` | `n` | Find words | Global |
| `<Leader>fW` | `n` | Find words in all files | Global |

### Git

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>gb` | `n` | Git branches | Global |
| `<Leader>gC` | `n` | Git commits (current file) | Global |
| `<Leader>gc` | `n` | Git commits (repository) | Global |
| `<Leader>gd` | `n` | View Git diff | Buffer-local |
| `<Leader>gg` | `n` | ToggleTerm lazygit | Global |
| `<Leader>gl` | `n` | View Git blame | Buffer-local |
| `<Leader>gL` | `n` | View full Git blame | Buffer-local |
| `<Leader>go` | `n/x` | Git browse (open) | Global |
| `<Leader>gp` | `n` | Preview Git hunk | Buffer-local |
| `<Leader>gR` | `n` | Reset Git buffer | Buffer-local |
| `<Leader>gr` | `n/x/s` | Reset Git hunk | Buffer-local |
| `<Leader>gS` | `n` | Stage Git buffer | Buffer-local |
| `<Leader>gs` | `n` | Stage/Unstage Git hunk | Buffer-local |
| `<Leader>gs` | `x/s` | Stage Git hunk | Buffer-local |
| `<Leader>gT` | `n` | Git stash | Global |
| `<Leader>gt` | `n` | Git status | Global |
| `<Leader>gu` | `n` | Undo stage hunk | Buffer-local |

### LSP

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>lA` | `n` | LSP source action | Buffer-local |
| `<Leader>la` | `n/x` | LSP code action | Buffer-local |
| `<Leader>ld` | `n` | Hover diagnostics | Global |
| `<Leader>lD` | `n` | Search diagnostics | Global |
| `<Leader>lG` | `n` | Search workspace symbols | Buffer-local |
| `<Leader>lh` | `n` | Signature help | Buffer-local |
| `<Leader>li` | `n` | Lsp Information | Global |
| `<Leader>ll` | `n` | LSP CodeLens refresh | Buffer-local |
| `<Leader>lL` | `n` | LSP CodeLens run | Buffer-local |
| `<Leader>lr` | `n` | Rename current symbol | Buffer-local |
| `<Leader>ls` | `n` | Search symbols | Global |
| `<Leader>lS` | `n` | Symbols outline | Global |

### Debugging

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>dB` | `n` | Clear Breakpoints | Global |
| `<Leader>db` | `n` | Toggle Breakpoint (F9) | Global |
| `<Leader>dC` | `n` | Conditional Breakpoint (S-F9) | Global |
| `<Leader>dc` | `n` | Start/Continue (F5) | Global |
| `<Leader>dE` | `n` | Evaluate Input | Global |
| `<Leader>dE` | `x/s` | Evaluate Selection | Global |
| `<Leader>dh` | `n` | Debugger Hover | Global |
| `<Leader>di` | `n` | Step Into (F11) | Global |
| `<Leader>dk` | `n` | DAP Hover | Global |
| `<Leader>dO` | `n` | Step Out (S-F11) | Global |
| `<Leader>do` | `n` | Step Over (F10) | Global |
| `<Leader>dp` | `n` | DAP Preview | Global |
| `<Leader>dq` | `n` | Close Session | Global |
| `<Leader>dQ` | `n` | Terminate Session (S-F5) | Global |
| `<Leader>dr` | `n` | Restart (C-F5) | Global |
| `<Leader>dR` | `n` | Toggle REPL | Global |
| `<Leader>ds` | `n` | Run to cursor | Global |
| `<Leader>du` | `n` | Toggle Debugger UI | Global |
| `<Leader>osv` | `n` | Start neovim lua debug server | Global |

### Terminal

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>tf` | `n` | ToggleTerm float | Global |
| `<Leader>th` | `n` | ToggleTerm horizontal split | Global |
| `<Leader>tl` | `n` | ToggleTerm lazygit | Global |
| `<Leader>tn` | `n` | ToggleTerm node | Global |
| `<Leader>tp` | `n` | ToggleTerm python | Global |
| `<Leader>tu` | `n` | ToggleTerm gdu | Global |
| `<Leader>tv` | `n` | ToggleTerm vertical split | Global |

### UI and feature toggles

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>u>` | `n` | Toggle foldcolumn | Global |
| `<Leader>u?` | `n` | Toggle automatic signature help | Buffer-local |
| `<Leader>ua` | `n` | Toggle autopairs | Global |
| `<Leader>uA` | `n` | Toggle rooter autochdir | Global |
| `<Leader>ub` | `n` | Toggle background | Global |
| `<Leader>uc` | `n` | Toggle autocompletion (buffer) | Global |
| `<Leader>uC` | `n` | Toggle autocompletion (global) | Global |
| `<Leader>uD` | `n` | Dismiss notifications | Global |
| `<Leader>ud` | `n` | Toggle diagnostics | Global |
| `<Leader>uf` | `n` | Toggle autoformatting (buffer) | Buffer-local |
| `<Leader>uF` | `n` | Toggle autoformatting (global) | Buffer-local |
| `<Leader>ug` | `n` | Toggle signcolumn | Global |
| `<Leader>uh` | `n` | Toggle LSP inlay hints (buffer) | Buffer-local |
| `<Leader>uH` | `n` | Toggle LSP inlay hints (global) | Buffer-local |
| `<Leader>ui` | `n` | Change indent setting | Global |
| `<Leader>uL` | `n` | Toggle CodeLens | Buffer-local |
| `<Leader>ul` | `n` | Toggle statusline | Global |
| `<Leader>un` | `n` | Change line numbering | Global |
| `<Leader>uN` | `n` | Toggle Notifications | Global |
| `<Leader>up` | `n` | Toggle paste mode | Global |
| `<Leader>ur` | `n` | Toggle reference highlighting | Global |
| `<Leader>uS` | `n` | Toggle conceal | Global |
| `<Leader>us` | `n` | Toggle spellcheck | Global |
| `<Leader>ut` | `n` | Toggle tabline | Global |
| `<Leader>uu` | `n` | Toggle URL highlight | Global |
| `<Leader>uV` | `n` | Toggle virtual lines | Global |
| `<Leader>uv` | `n` | Toggle virtual text | Global |
| `<Leader>uw` | `n` | Toggle wrap | Global |
| `<Leader>uY` | `n` | Toggle LSP semantic highlight (buffer) | Buffer-local |
| `<Leader>uy` | `n` | Toggle syntax highlight (buffer) | Global |
| `<Leader>uz` | `n` | Toggle color highlight | Global |
| `<Leader>uZ` | `n` | Toggle zen mode | Global |
| `<Leader>u\|` | `n` | Toggle indent guides | Global |

### Quickfix and location lists

| Key | Mode | Action | Scope |
| --- | --- | --- | --- |
| `<Leader>xl` | `n` | Location List | Global |
| `<Leader>xq` | `n` | Quickfix List | Global |

## Non-leader global mappings

### Control, Alt, and function keys

| Key | Mode | Action |
| --- | --- | --- |
| `<A-j>` | `n` | Next yank history entry |
| `<A-k>` | `n` | Previous yank history entry |
| `<b` | `n` | Move buffer tab left |
| `<C-Down>` | `n` | Resize split down |
| `<C-F5>` | `n` | Debugger: Restart |
| `<C-H>` | `n` | Move to left split |
| `<C-J>` | `n` | Move to below split |
| `<C-K>` | `n` | Move to above split |
| `<C-L>` | `n` | Move to right split |
| `<C-Left>` | `n` | Resize split left |
| `<C-N>` | `n/i` | Toggle Explorer |
| `<C-P>` | `n/i/x` | Find files |
| `<C-Right>` | `n` | Resize split right |
| `<C-S>` | `i/s` | vim.lsp.buf.signature_help() |
| `<C-S>` | `x` | Force write |
| `<C-U>` | `i` | :help i_CTRL-U-default |
| `<C-Up>` | `n` | Resize split up |
| `<C-W>` | `i` | :help i_CTRL-W-default |
| `<C-W><C-D>` | `n` | Show diagnostics under the cursor |
| `<C-W>d` | `n` | Show diagnostics under the cursor |
| `<CR>` | `i` | autopairs completion confirm |
| `<F10>` | `n` | Step over |
| `<F11>` | `n` | Step into |
| `<F5>` | `n` | Continue |
| `<F6>` | `n` | Debugger: Pause |
| `<F9>` | `n` | Toggle breakpoint |
| `<S-F11>` | `n` | Step out (S-F11) |
| `<S-F5>` | `n` | Terminate (S-F5) |
| `<S-F9>` | `n` | Conditional breakpoint (S-F9) |
| `<S-Tab>` | `i` | vim.snippet.jump if active, otherwise <S-Tab> |
| `<S-Tab>` | `n` | Previous buffer |
| `<S-Tab>` | `x/s` | Unindent line |
| `<Tab>` | `i` | vim.snippet.jump if active, otherwise <Tab> |
| `<Tab>` | `n` | Next buffer |
| `<Tab>` | `x/s` | Indent line |

### Bracket navigation

| Key | Mode | Action |
| --- | --- | --- |
| `[ ` | `n` | Add empty line above cursor |
| `[<C-L>` | `n` | :lpfile |
| `[<C-Q>` | `n` | :cpfile |
| `[<C-T>` | `n` | :ptprevious |
| `[a` | `n` | :previous |
| `[A` | `n` | :rewind |
| `[B` | `n` | :brewind |
| `[D` | `n` | Jump to the first diagnostic in the current buffer |
| `[d` | `n` | Jump to the previous diagnostic in the current buffer |
| `[e` | `n` | Previous error |
| `[l` | `n` | :lprevious |
| `[L` | `n` | :lrewind |
| `[n` | `x` | Select previous node |
| `[N` | `x` | Select previous sibling node |
| `[q` | `n` | :cprevious |
| `[Q` | `n` | :crewind |
| `[r` | `n` | Previous reference |
| `[T` | `n` | Previous TODO comment |
| `[t` | `n` | Previous tab |
| `[w` | `n` | Previous warning |
| `] ` | `n` | Add empty line below cursor |
| `]<C-L>` | `n` | :lnfile |
| `]<C-Q>` | `n` | :cnfile |
| `]<C-T>` | `n` | :ptnext |
| `]A` | `n` | :last |
| `]a` | `n` | :next |
| `]B` | `n` | :blast |
| `]D` | `n` | Jump to the last diagnostic in the current buffer |
| `]d` | `n` | Jump to the next diagnostic in the current buffer |
| `]e` | `n` | Next error |
| `]L` | `n` | :llast |
| `]l` | `n` | :lnext |
| `]n` | `x` | Select next node |
| `]N` | `x` | Select next sibling node |
| `]Q` | `n` | :clast |
| `]q` | `n` | :cnext |
| `]r` | `n` | Next reference |
| `]T` | `n` | Next TODO comment |
| `]t` | `n` | Next tab |
| `]w` | `n` | Next warning |

### Editing, motions, operators, and comments

| Key | Mode | Action |
| --- | --- | --- |
| `#` | `x` | :help v_#-default |
| `&` | `n` | :help &-default |
| `*` | `x` | :help v_star-default |
| `>b` | `n` | Move buffer tab right |
| `@` | `x` | :help v_@-default |
| `an` | `x/o` | Select parent (outer) node |
| `gc` | `n/x` | Toggle comment |
| `gc` | `o` | Comment textobject |
| `gcA` | `n` | Add comment at end of line |
| `gcc` | `n` | Toggle comment line |
| `gcO` | `n` | Add Comment Above |
| `gco` | `n` | Add Comment Below |
| `gl` | `n` | Hover diagnostics |
| `gO` | `n` | vim.lsp.buf.document_symbol() |
| `gp` | `n/x` | Put after and move cursor |
| `gP` | `n/x` | Put before and move cursor |
| `gx` | `n/x` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| `in` | `x/o` | Select child (inner) node |
| `j` | `n/x` | Move cursor down |
| `k` | `n/x` | Move cursor up |
| `M` | `n` | Substitute EOL |
| `m` | `n` | Substitute Operator |
| `m` | `x` | Substitute Visual |
| `mm` | `n` | Substitute Line |
| `mx` | `n` | Substitute Exchange Operator |
| `mxc` | `n` | Substitute Exchange Cancel |
| `mxx` | `n` | Substitute Exchange Line |
| `p` | `n/x` | Put after with Yanky |
| `P` | `n/x` | Put before with Yanky |
| `Q` | `x` | :help v_Q-default |
| `r` | `o` | Remote Flash |
| `R` | `x/o` | Treesitter Search |
| `s` | `n/x/o` | Flash Jump |
| `S` | `n/x/o` | Flash Treesitter |
| `X` | `x` | Substitute Exchange Visual |
| `Y` | `n` | :help Y-default |
| `zM` | `n` | Close all folds |
| `zR` | `n` | Open all folds |
| `zt` | `n/x` | Scroll line to top with context |
| `\|` | `n` | Vertical Split |

### Terminal navigation

| Key | Mode | Action |
| --- | --- | --- |
| `<C-'>` | `n/i/t` | Toggle terminal |
| `<C-H>` | `t` | Terminal left window navigation |
| `<C-J>` | `t` | Terminal down window navigation |
| `<C-K>` | `t` | Terminal up window navigation |
| `<C-L>` | `t` | Terminal right window navigation |
| `<F7>` | `n/i/t` | Toggle terminal |

### Command-line completion and search

| Key | Mode | Action |
| --- | --- | --- |
| `<C-E>` | `c` | blink.cmp: Cancel |
| `<C-N>` | `c` | blink.cmp: Select Next |
| `<C-P>` | `c` | blink.cmp: Select Prev |
| `<C-S>` | `c` | Toggle Flash Search |
| `<C-Space>` | `c` | blink.cmp: Show |
| `<C-Y>` | `c` | blink.cmp: Select And Accept |
| `<End>` | `c` | blink.cmp: Hide |
| `<Left>` | `c` | blink.cmp: Select Prev |
| `<Right>` | `c` | blink.cmp: Select Next |
| `<S-Tab>` | `c` | blink.cmp: <Custom Fn>, Select Prev |
| `<Tab>` | `c` | blink.cmp: Show And Insert Or Accept Single, Select Next |

## Conditional buffer-local mappings

Buffer-local mappings override a global mapping with the same key while their integration is active.

### LSP and symbols

| Key | Mode | Action |
| --- | --- | --- |
| `[y` | `n` | Previous symbol |
| `[Y` | `n` | Previous symbol upwards |
| `]y` | `n` | Next symbol |
| `]Y` | `n` | Next symbol upwards |
| `gd` | `n` | Show definitions in Glance |
| `gi` | `n` | Show implementations in Glance |
| `gK` | `n` | Signature help |
| `gr` | `n` | Show references in Glance |
| `gy` | `n` | Show type definitions in Glance |
| `K` | `n` | vim.lsp.buf.hover() |

### Gitsigns

| Key | Mode | Action |
| --- | --- | --- |
| `[G` | `n` | First Git hunk |
| `[g` | `n` | Previous Git hunk |
| `]G` | `n` | Last Git hunk |
| `]g` | `n` | Next Git hunk |
| `ig` | `x/o` | inside Git hunk |

### Treesitter text objects and navigation

| Key | Mode | Action |
| --- | --- | --- |
| `<A` | `n` | Swap previous argument |
| `<BS>` | `x` | Shrink selection to previous named node |
| `<F` | `n` | Swap previous function |
| `<K` | `n` | Swap previous block |
| `>A` | `n` | Swap next argument |
| `>F` | `n` | Swap next function |
| `>K` | `n` | Swap next block |
| `[A` | `n/x/o` | Previous argument end |
| `[a` | `n/x/o` | Previous argument start |
| `[F` | `n/x/o` | Previous function end |
| `[f` | `n/x/o` | Previous function start |
| `[K` | `n/x/o` | Previous block end |
| `[k` | `n/x/o` | Previous block start |
| `\` | `n` | Start selecting nodes with treesitter-modules |
| `\` | `x` | Increment selection to named node |
| `]A` | `n/x/o` | Next argument end |
| `]a` | `n/x/o` | Next argument start |
| `]F` | `n/x/o` | Next function end |
| `]f` | `n/x/o` | Next function start |
| `]K` | `n/x/o` | Next block end |
| `]k` | `n/x/o` | Next block start |
| `a?` | `x/o` | around conditional |
| `aa` | `x/o` | around argument |
| `ac` | `x/o` | around class when the language query provides class captures |
| `af` | `x/o` | around function |
| `ak` | `x/o` | around block |
| `ao` | `x/o` | around loop |
| `i?` | `x/o` | inside conditional |
| `ia` | `x/o` | inside argument |
| `ic` | `x/o` | inside class when the language query provides class captures |
| `if` | `x/o` | inside function |
| `ik` | `x/o` | inside block |
| `io` | `x/o` | inside loop |

### Autopairs

| Key | Mode | Action |
| --- | --- | --- |
| `"` | `i` | autopairs map key |
| `'` | `i` | autopairs map key |
| `(` | `i` | autopairs map key |
| `)` | `i` | autopairs map key |
| `<A-e>` | `i` | autopairs fastwrap |
| `<BS>` | `i` | autopairs delete |
| `[` | `i` | autopairs map key |
| `]` | `i` | autopairs map key |
| `` ` `` | `i` | autopairs map key |
| `{` | `i` | autopairs map key |
| `}` | `i` | autopairs map key |

## Mappings managed inside plugins

These active mappings do not appear reliably in `nvim_get_keymap()` because their plugins process the keys internally.

### Insert completion and escape

| Key | Mode | Action |
| --- | --- | --- |
| `<A-Space>` | `i` | Show completion; show or hide documentation |
| `<C-J>` | `i` | Select next completion item; otherwise use the key normally |
| `<C-K>` | `i` | Select previous completion item; otherwise use the key normally |
| `jk` | `i` | Exit Insert mode with Better Escape |
| `jj` | `i` | Exit Insert mode with Better Escape |

### Surround

| Key | Mode | Action |
| --- | --- | --- |
| `ys{motion}{char}` | `n` | Add a surrounding pair |
| `ds{char}` | `n` | Delete a surrounding pair |
| `cs{old}{new}` | `n` | Change a surrounding pair |

### Capability-dependent LSP fallback

| Key | Mode | Action |
| --- | --- | --- |
| `gD` | `n` | Go to declaration when the attached server supports declarations |

## Intentionally disabled or reserved mappings

| Key | Mode | Reason / replacement |
| --- | --- | --- |
| `<Leader>w` | `n` | Disabled AstroNvim save alias. |
| `<C-S>` | `n` | Disabled normal-mode save alias; Insert mode uses signature help and Visual mode keeps force-write. |
| `<Leader>q` | `n` | Disabled quit-window alias. |
| `<Leader>Q` | `n` | Disabled exit-Neovim alias. |
| `<C-Q>` | `n` | Disabled force-quit alias. |
| `<Leader>n` | `n` | Disabled new-file alias; diagnostics use bracket mappings. |
| `<Leader>ff` | `n` | Use `<C-P>` to find files. |
| `<Leader>e` | `n` | Use `<C-N>` to toggle Neo-tree. |
| `<Leader>o` | `n` | Explorer focus alias removed. |
| `<Leader>/` | `n/x` | Use `gcc` for a line or `gc` for a selection/motion. |
| `]b` | `n` | Use `<Tab>` for the next buffer. |
| `[b` | `n` | Use `<S-Tab>` for the previous buffer. |
| `\` | `global n` | Horizontal-split alias removed; parser buffers use `\` for Treesitter selection. |
| `grr` | `n` | Use Glance references on `gr`. |
| `gri` | `n` | Use Glance implementations on `gi`. |
| `gra` | `n/x` | Use `<Leader>la` for code actions. |
| `grn` | `n` | Use `<Leader>lr` to rename. |
| `grt` | `n` | Use Glance type definitions on `gy`. |
| `grx` | `n` | Use `<Leader>lL` to run CodeLens. |
| `<Leader>lR` | `LSP n` | Use Glance references on `gr`. |
| `<Leader>lf` | `LSP n/x` | Use Conform on `<Leader>fm`. |
| `<C-Space>` | `Blink i` | Completion moved to `<A-Space>`. |
| `<C-N>` | `Blink i` | Reserved for toggling Neo-tree. |
| `<C-P>` | `Blink i` | Reserved for finding files. |

### Plugin-management shortcuts

The following AstroNvim plugin-management shortcuts are disabled:

`<Leader>pi`, `<Leader>ps`, `<Leader>pS`, `<Leader>pu`, `<Leader>pU`, `<Leader>pm`, `<Leader>pM`, `<Leader>pa`.

## Source of truth

- Global overrides and removals: `lua/plugins/astrocore.lua`
- LSP attachment mappings: `lua/plugins/astrolsp.lua`
- Plugin-owned mappings: the corresponding files under `lua/plugins/`
- Runtime inventory used for this document: Neovim global mappings plus a real Lua buffer with `lua_ls`, Gitsigns, Treesitter, Aerial, and Autopairs attached; language-dependent Treesitter mappings were checked against AstroNvim's configured text-object source.
