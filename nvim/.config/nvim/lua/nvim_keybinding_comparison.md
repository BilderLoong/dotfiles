move one action

Last verified: 2026-08-29

## Scope

- **NvChad baseline:** Git revision `f7ce9e03`, the last tracked NvChad configuration before its files were deleted.
- **AstroNvim baseline:** the active configuration loaded from `~/.config/nvim` with Neovim 0.11.1 and AstroNvim 6.0.4.
- The NvChad side is exact only for the tracked custom source. Rows marked **Unverified** keep a stock NvChad claim for migration context, but the repository does not contain the final stock NvChad runtime or dependency lock.
- This document includes global mappings, explicit buffer-local mappings, tracked plugin entry mappings, and plugin defaults that are important for migration. It does not list picker-internal or other UI-local mappings. It lists a stock Neovim key only when one configuration overrides or reuses it.
- A lazy-loaded plugin can replace an earlier mapping. For example, AstroNvim first maps normal-mode `<leader>fm` to Find manual pages. Conform replaces that mapping after Conform loads on `BufWritePre`.
- LSP mappings are available only when a compatible language server attaches.
- Gitsigns mappings are available only in Git-controlled buffers.
- Treesitter text-object mappings require a parser and a matching query for the current file type.

## State legend

- **Same:** the key and functionality are effectively the same.
- **Changed:** the key, tool, mode, or behavior changed, but similar functionality remains.
- **Removed:** the NvChad mapping has no current equivalent.
- **New:** the current mapping has no tracked NvChad equivalent.
- **Unverified:** the mapping is attributed to stock NvChad, but it is not present in the tracked custom source and there is no saved stock runtime to verify it.

## Conflict notes

- **Conflict:** the same mode and complete key run different functions. Example: normal-mode `<leader>n` goes to the next diagnostic in NvChad, but it creates a new file in AstroNvim.
- **Prefix risk:** one configuration maps a shorter key that starts a longer mapping in the other configuration. Example: AstroNvim maps `<leader>c` to close the current buffer, while NvChad uses `<leader>ca`, `<leader>cd`, and `<leader>cg`.
- **Runtime collision:** the active function changes after a lazy-loaded plugin replaces a mapping. Example: normal-mode `<leader>fm` starts as Find manual pages and becomes Format buffer after Conform loads.


## General

-a mean: disable current astronvim key
+a mean: use nvchad key instead of astronvim key.
| Functionality                                | NvChad key                         | AstroNvim key                  | State   | Note                                                                      |
| -------------------------------------------- | ---------------------------------- | ------------------------------ | ------- | ------------------------------------------------------------------------- |
| Exit insert mode                             | `i: jk`                            | `i: jk` with Better Escape     | Changed | Same key and function, but the plugin and timing differ.                  |
| Exit insert mode with the alternate shortcut | —                                  | `i: jj` with Better Escape     | New     |                                                                           |
| Scroll current line to the top               | `n/v: zt` with three context lines | `n/v: zt` with native behavior | Changed | +a; AstroNvim does not add the three context lines.                       |
| Export the current project to VS Code        | `n: <leader>cd`                    | —                              | Removed | +a as `n: <leader>vs`; keep AstroNvim's `<leader>c` buffer-close mapping. |
| Open the Neovim configuration                | `n: <leader>cg`                    | —                              | Removed | **Prefix risk:** AstroNvim's `<leader>c` closes the buffer.               |
| Keep `<leader>D` unassigned                  | `n: <leader>D` disabled            | `n: <leader>D` unassigned      | Same    |                                                                           |
| Save the current file                        | —                                  | `n: <leader>w`                 | New     | -a                                                                        |
| Force-write the current file                 | —                                  | `n: <C-S>`                     | New     | -a                                                                        |
| Quit the current window                      | —                                  | `n: <leader>q`                 | New     | -a                                                                        |
| Exit Neovim                                  | —                                  | `n: <leader>Q`                 | New     | -a                                                                        |
| Force-quit the current window                | —                                  | `n: <C-Q>`                     | New     | -a                                                                        |
| Create a new empty file                      | —                                  | `n: <leader>n`                 | New     | -a; **Conflict:** NvChad = next diagnostic.                               |
| Rename the current file                      | —                                  | `n: <leader>R`                 | New     |                                                                           |
| Close the current buffer                     | —                                  | `n: <leader>c`                 | New     | **Prefix risk:** NvChad has `<leader>ca`, `<leader>cd`, and `<leader>cg`. |
| Force-close the current buffer               | —                                  | `n: <leader>C`                 | New     |                                                                           |
| Open the AstroNvim home screen               | —                                  | `n: <leader>h`                 | New     |                                                                           |

## Finding and pickers

| Functionality                                       | NvChad key                   | AstroNvim key                        | State      | Note                                                                      |
| --------------------------------------------------- | ---------------------------- | ------------------------------------ | ---------- | ------------------------------------------------------------------------- |
| Find files                                          | `n: <leader>ff`              | `n: <leader>ff`                      | Unverified | Use `n/i/x: <C-P>` instead; disable `<leader>ff`.                         |
| Search text in project files                        | `n: <leader>fw` with Fzf-lua | `n: <leader>fw` with Snacks          | Changed      |                                                                           |
| Search text in hidden and ignored files             | —                            | `n: <leader>fW`                      | New        |                                                                           |
| Resume the previous Fzf-lua search                  | `n: <leader>rr`              | `n: <leader>f<CR>`                   | Changed    |                                                                           |
| Resume the previous Telescope picker                | `n/i: <A-r>`                 | `n: <leader>f<CR>`                   | Changed    |                                                                           |
| Find help tags                                      | `n: <F1>`                    | `n: <leader>fh`                      | Changed    |                                                                           |
| Open the Telescope built-in picker                  | `n/i: <A-b>`                 | —                                    | Removed    |                                                                           |
| Find commands                                       | `n/i: <A-p>`                 | `n: <leader>fC`                      | Changed    |                                                                           |
| Find AST-grep results                               | `n: <leader>sg`              | —                                    | Removed    | +a as `n: <leader>fA` using a project-wide Snacks/ast-grep picker.         |
| Find buffers                                        | —                            | `n: <leader>fb`                      | New        |                                                                           |
| Find Git files                                      | —                            | `n: <leader>fg`                      | New        |                                                                           |
| Find recent files                                   | —                            | `n: <leader>fo`                      | New        |                                                                           |
| Find recent files in the current directory          | —                            | `n: <leader>fO`                      | New        |                                                                           |
| Find the word under the cursor                      | —                            | `n: <leader>fc`                      | New        |                                                                           |
| Find keybindings                                    | —                            | `n: <leader>fk`                      | New        |                                                                           |
| Find registers                                      | —                            | `n: <leader>fr`                      | New        |                                                                           |
| Find manual pages                                   | —                            | `n: <leader>fm` before Conform loads | New        | Move to `n: <leader>fM`; reserve `<leader>fm` for Conform.                 |
| Find notifications                                  | —                            | `n: <leader>fn`                      | New        |                                                                           |
| Find color schemes                                  | —                            | `n: <leader>ft`                      | New        |                                                                           |
| Find projects                                       | —                            | `n: <leader>fp`                      | New        |                                                                           |
| Find undo history                                   | —                            | `n: <leader>fu`                      | New        |                                                                           |
| Find TODO comments                                  | —                            | `n: <leader>fT`                      | New        |                                                                           |
| Go to the previous TODO comment                     | —                            | `n: [T`                              | New        |                                                                           |
| Go to the next TODO comment                         | —                            | `n: ]T`                              | New        |                                                                           |
| Find lines in the current buffer                    | —                            | `n: <leader>fl`                      | New        |                                                                           |
| Find marks                                          | —                            | `n: <leader>f'`                      | New        |                                                                           |
| Find hidden and ignored files                       | —                            | `n: <leader>fF`                      | New        |                                                                           |
| Find AstroNvim configuration files                  | —                            | `n: <leader>fa`                      | New        |                                                                           |
| Open the smart file, buffer, and recent-file picker | —                            | `n: <leader>fs`                      | New        | **Conflict:** NvChad = find workspace symbols.                            |

## File explorer

| Functionality                                            | NvChad key                   | AstroNvim key                | State      | Note                                                              |
| -------------------------------------------------------- | ---------------------------- | ---------------------------- | ---------- | ----------------------------------------------------------------- |
| Toggle the file explorer                                 | `n: <leader>e` with NvimTree | `n: <leader>e` with Neo-tree | Unverified | Use `n/i: <C-N>`; disable `<leader>e`.                         |
| Focus the file explorer or return to the previous window | —                            | `n: <leader>o`               | New        | -a                                                                |

## LSP and diagnostics

| Functionality                               | NvChad key                   | AstroNvim key                      | State   | Note                                                        |
| ------------------------------------------- | ---------------------------- | ---------------------------------- | ------- | ----------------------------------------------------------- |
| Go to definition                            | `n: gd` with Glance          | `n: gd` with the native LSP client | Changed | Use Glance on `gd`.                                         |
| Go to type definition                       | `n: gy` with Glance          | `n: gy` with the native LSP client | Changed | Use Glance on `gy`.                                         |
| Find references                             | `n: gr` with Glance          | `n: grr` or `<leader>lR`           | Changed | Use Glance on `gr`; remove `grr` and `<leader>lR`.          |
| Go to the previous reference                | —                            | `n: [r`                            | New     | Provided by Snacks when references are available.           |
| Go to the next reference                    | —                            | `n: ]r`                            | New     | Provided by Snacks when references are available.           |
| Find implementations                        | `n: gi` with Telescope       | `n: gri`                           | Changed | Use Glance on `gi`; remove `gri`.                         |
| Open a symbols outline                      | `n: gO` with Lspsaga         | `n: <leader>lS`                    | Changed | **Conflict:** AstroNvim = find document symbols.            |
| Find document symbols                       | `n/i: <A-d>` with Telescope  | `n: gO`                            | Changed | **Conflict:** NvChad = open the symbols outline.            |
| Open the Lspsaga finder                     | `n: ga`                      | —                                  | Removed |                                                             |
| Show hover documentation                    | `n: K` with Lspsaga          | `n: K` with the native LSP client  | Changed |                                                             |
| Run a code action                           | `n: <leader>ca` with Lspsaga | `n/x: gra` or `<leader>la`         | Changed | Use `<leader>la`; remove `gra`.                             |
| Go to the next diagnostic                   | `n: <leader>n`               | `n: ]d`                            | Changed | **Conflict:** AstroNvim = create a new file.                |
| Find workspace symbols                      | `n: <leader>fs` with Fzf-lua | `n: <leader>lG`                    | Changed | **Conflict:** AstroNvim = smart file picker.                |
| Go to a declaration                         | —                            | `n: gD`                            | New     |                                                             |
| Rename the current symbol                   | —                            | `n: grn` or `<leader>lr`           | New     | Use `<leader>lr`; remove `grn`.                             |
| Show signature help                         | —                            | `n: gK` or `<leader>lh`            | New     |                                                             |
| Show signature help in insert mode          | —                            | `i: <C-S>`                         | New     |                                                             |
| Run an LSP source action                    | —                            | `n: <leader>lA`                    | New     |                                                             |
| Refresh CodeLens                            | —                            | `n: <leader>ll`                    | New     |                                                             |
| Run CodeLens                                | —                            | `n: <leader>lL`                    | New     |                                                             |
| Show LSP health information                 | —                            | `n: <leader>li`                    | New     |                                                             |
| Show diagnostics under the cursor           | —                            | `n: <leader>ld` or `gl`            | New     |                                                             |
| Search diagnostics                          | —                            | `n: <leader>lD`                    | New     |                                                             |
| Search symbols                              | —                            | `n: <leader>ls`                    | New     |                                                             |
| Go to the previous diagnostic               | —                            | `n: [d`                            | New     |                                                             |
| Go to the first diagnostic                  | —                            | `n: [D`                            | New     |                                                             |
| Go to the last diagnostic                   | —                            | `n: ]D`                            | New     |                                                             |
| Go to the previous error                    | —                            | `n: [e`                            | New     |                                                             |
| Go to the next error                        | —                            | `n: ]e`                            | New     |                                                             |
| Go to the previous warning                  | —                            | `n: [w`                            | New     |                                                             |
| Go to the next warning                      | —                            | `n: ]w`                            | New     |                                                             |
| Toggle CodeLens                             | —                            | `n: <leader>uL`                    | New     |                                                             |
| Toggle buffer autoformatting                | —                            | `n: <leader>uf`                    | New     |                                                             |
| Toggle global autoformatting                | —                            | `n: <leader>uF`                    | New     |                                                             |
| Toggle automatic signature help             | —                            | `n: <leader>u?`                    | New     |                                                             |
| Toggle buffer inlay hints                   | —                            | `n: <leader>uh`                    | New     |                                                             |
| Toggle global inlay hints                   | —                            | `n: <leader>uH`                    | New     |                                                             |
| Toggle semantic highlighting for the buffer | —                            | `n: <leader>uY`                    | New     |                                                             |
| Go to the previous symbol in Aerial         | —                            | `n: [y`                            | New     | Available only in an Aerial buffer.                         |
| Go to the next symbol in Aerial             | —                            | `n: ]y`                            | New     | Available only in an Aerial buffer.                         |
| Go upward to the previous symbol in Aerial  | —                            | `n: [Y`                            | New     | Available only in an Aerial buffer.                         |
| Go upward to the next symbol in Aerial      | —                            | `n: ]Y`                            | New     | Available only in an Aerial buffer.                         |

## Git and Gitsigns

| Functionality                             | NvChad key                   | AstroNvim key               | State   | Note          |
| ----------------------------------------- | ---------------------------- | --------------------------- | ------- | ------------- |
| Open Lazygit                              | —                            | `n: <leader>gg`             | New     |               |
| Open the repository location in a browser | —                            | `n/x: <leader>go`           | New     |               |
| Find Git branches                         | —                            | `n: <leader>gb`             | New     |               |
| Find repository commits                   | —                            | `n: <leader>gc`             | New     |               |
| Find commits for the current file         | —                            | `n: <leader>gC`             | New     |               |
| Find Git status entries                   | `n: <leader>gt` with Fzf-lua | `n: <leader>gt` with Snacks | Changed |               |
| Find Git stashes                          | —                            | `n: <leader>gT`             | New     |               |
| Stage a Git hunk                          | `n/v: <leader>ghs`           | `n/v: <leader>gs`           | Changed |               |
| Reset a Git hunk                          | `n/v: <leader>ghr`           | `n/v: <leader>gr`           | Changed |               |
| Undo the last stage-hunk operation        | `n/v: <leader>ghu`           | —                           | Removed | +a as `n: <leader>gu`. |
| Select a Git hunk text object             | `x/o: ih`                    | `x/o: ig`                   | Changed |               |
| Show blame for the current line           | —                            | `n: <leader>gl`             | New     |               |
| Show full blame for the current line      | —                            | `n: <leader>gL`             | New     |               |
| Preview the current Git hunk              | —                            | `n: <leader>gp`             | New     |               |
| Reset the current Git buffer              | —                            | `n: <leader>gR`             | New     |               |
| Stage the current Git buffer              | —                            | `n: <leader>gS`             | New     |               |
| Show the current Git diff                 | —                            | `n: <leader>gd`             | New     |               |
| Go to the previous Git hunk               | —                            | `n: [g`                     | New     |               |
| Go to the next Git hunk                   | —                            | `n: ]g`                     | New     |               |
| Go to the first Git hunk                  | —                            | `n: [G`                     | New     |               |
| Go to the last Git hunk                   | —                            | `n: ]G`                     | New     |               |

## Debugging

| Functionality                                  | NvChad key       | AstroNvim key               | State | Note |
| ---------------------------------------------- | ---------------- | --------------------------- | ----- | ---- |
| Toggle a breakpoint                            | `n: <F9>`        | `n: <F9>`                   | Same  |      |
| Add a conditional breakpoint                   | `n: <S-F9>`      | `n: <S-F9>`                 | Same  |      |
| Step over                                      | `n: <F10>`       | `n: <F10>`                  | Same  |      |
| Step into                                      | `n: <F11>`       | `n: <F11>`                  | Same  |      |
| Step out                                       | `n: <S-F11>`     | `n: <S-F11>`                | Same  |      |
| Continue execution                             | `n: <F5>`        | `n: <F5>`                   | Same  |      |
| Terminate execution                            | `n: <S-F5>`      | `n: <S-F5>`                 | Same  |      |
| Preview a value                                | `n: <leader>dp`  | `n: <leader>dp`             | Same  |      |
| Show DAP hover information                     | `n: <leader>dk`  | `n: <leader>dk`             | Same  |      |
| Run to the cursor                              | `n: <leader>ds`  | `n: <leader>ds`             | Same  |      |
| Toggle the debugger UI                         | `n: <leader>du`  | `n: <leader>du`             | Same  |      |
| Start the Neovim Lua debug server              | `n: <leader>osv` | `n: <leader>osv`            | Same  |      |
| Pause execution                                | —                | `n: <F6>`                   | New   |      |
| Restart the current frame                      | —                | `n: <C-F5>` or `<leader>dr` | New   |      |
| Toggle a breakpoint with a leader key          | —                | `n: <leader>db`             | New   |      |
| Clear all breakpoints                          | —                | `n: <leader>dB`             | New   |      |
| Start or continue execution                    | —                | `n: <leader>dc`             | New   |      |
| Add a conditional breakpoint with a leader key | —                | `n: <leader>dC`             | New   |      |
| Step into with a leader key                    | —                | `n: <leader>di`             | New   |      |
| Step over with a leader key                    | —                | `n: <leader>do`             | New   |      |
| Step out with a leader key                     | —                | `n: <leader>dO`             | New   |      |
| Close the debug session                        | —                | `n: <leader>dq`             | New   |      |
| Terminate the debug session                    | —                | `n: <leader>dQ`             | New   |      |
| Toggle the debugger REPL                       | —                | `n: <leader>dR`             | New   |      |
| Show debugger hover information                | —                | `n: <leader>dh`             | New   |      |
| Evaluate an expression                         | —                | `n/x: <leader>dE`           | New   |      |

## Sessions

| Functionality         | NvChad key      | AstroNvim key | State   | Note                                 |
| --------------------- | --------------- | ------------- | ------- | ------------------------------------ |
| Search saved sessions | `n: <leader>ss` | —             | Removed | +a as `n: <leader>fS` using Auto Session's Snacks picker. |

## Formatting and folds

| Functionality                                                 | NvChad key       | AstroNvim key                       | State   | Note                                                                   |
| ------------------------------------------------------------- | ---------------- | ----------------------------------- | ------- | ---------------------------------------------------------------------- |
| Format the current buffer with Conform                        | `n: <leader>fm`  | `n: <leader>fm` after Conform loads | Same    | Keep `<leader>fm`; move Find manual pages to `<leader>fM`.              |
| Format a visual selection with Conform                        | `v: <leader>fm`  | `v: <leader>fm`                     | Same    |                                                                        |
| Run Conform from operator-pending mode; it formats the buffer | `o: <leader>fm`  | `o: <leader>fm`                     | Same    | This is not motion-based. Conform detects a range only in Visual mode. |
| Format through the active LSP client                          | —                | `n/v: <leader>lf`                   | New     | -a; Conform already falls back to LSP formatting.                      |
| Close all folds                                               | `n: zM` with UFO | `n: zM` with native fold behavior   | Changed | +a; use UFO so `foldlevel` stays at 99.                                |
| Open all folds                                                | `n: zR` with UFO | `n: zR` with native fold behavior   | Changed | +a; use UFO so `foldlevel` stays at 99.                                |

## Haskell tools

| Functionality                 | NvChad key      | AstroNvim key | State   | Note |
| ----------------------------- | --------------- | ------------- | ------- | ---- |
| Evaluate all Haskell snippets | `n: <leader>re` | —             | Removed |      |
| Stop the GHCi REPL            | `n: <leader>rq` | —             | Removed |      |
| Toggle the GHCi REPL          | `n: <leader>rf` | —             | Removed |      |

## Completion, Copilot, and Treesitter

| Functionality                                    | NvChad key                   | AstroNvim key             | State   | Note                                                                  |
| ------------------------------------------------ | ---------------------------- | ------------------------- | ------- | --------------------------------------------------------------------- |
| Open completion                                  | `i: <A-Space>` with nvim-cmp | `i: <C-Space>` with Blink | Changed | Use `<A-Space>`; disable Blink's `<C-Space>`.                          |
| Select the next completion item                  | —                            | `i: <C-N>` or `<C-J>`     | New     | Disable Blink's `<C-N>`; keep `<C-J>`.                                 |
| Select the previous completion item              | —                            | `i: <C-P>` or `<C-K>`     | New     | Disable Blink's `<C-P>`; keep `<C-K>`.                                 |
| Accept a Copilot suggestion                      | `i: <C-J>`                   | —                         | Removed | **Conflict:** AstroNvim uses `i: <C-J>` for the next completion item. |
| Select the smart Treesitter text subject         | `x/o: .`                     | —                         | Removed | Intentionally disabled: textsubjects is incompatible with Treesitter `main`. |
| Select the outer Treesitter container            | `x/o: ;`                     | —                         | Removed | Intentionally disabled: textsubjects is incompatible with Treesitter `main`. |
| Select the inner Treesitter container            | `x/o: i;`                    | —                         | Removed | Intentionally disabled: textsubjects is incompatible with Treesitter `main`. |
| Select around a Treesitter block                 | `x/o: ak`                    | `x/o: ak`                 | Same    |                                                                       |
| Select inside a Treesitter block                 | `x/o: ik`                    | `x/o: ik`                 | Same    |                                                                       |
| Select around a Treesitter class                 | `x/o: ac`                    | `x/o: ac`                 | Same    |                                                                       |
| Select inside a Treesitter class                 | `x/o: ic`                    | `x/o: ic`                 | Same    |                                                                       |
| Select around a Treesitter conditional           | `x/o: a?`                    | `x/o: a?`                 | Same    |                                                                       |
| Select inside a Treesitter conditional           | `x/o: i?`                    | `x/o: i?`                 | Same    |                                                                       |
| Select around a Treesitter function              | `x/o: af`                    | `x/o: af`                 | Same    |                                                                       |
| Select inside a Treesitter function              | `x/o: if`                    | `x/o: if`                 | Same    |                                                                       |
| Select around a Treesitter loop                  | `x/o: al`                    | `x/o: ao`                 | Changed | Keep `ao`; `al` conflicts with Targets' last-target modifier.            |
| Select inside a Treesitter loop                  | `x/o: il`                    | `x/o: io`                 | Changed | Keep `io`; `il` conflicts with Targets' last-target modifier.            |
| Select around a Treesitter argument              | `x/o: aa`                    | `x/o: aa`                 | Same    |                                                                       |
| Select inside a Treesitter argument              | `x/o: ia`                    | `x/o: ia`                 | Same    |                                                                       |
| Go to the next Treesitter block start            | `n/x/o: ]k`                  | `n/x/o: ]k`               | Same    |                                                                       |
| Go to the next Treesitter function start         | `n/x/o: ]f`                  | `n/x/o: ]f`               | Same    |                                                                       |
| Go to the next Treesitter argument start         | `n/x/o: ]a`                  | `n/x/o: ]a`               | Same    |                                                                       |
| Go to the next Treesitter block end              | `n/x/o: ]K`                  | `n/x/o: ]K`               | Same    |                                                                       |
| Go to the next Treesitter function end           | `n/x/o: ]F`                  | `n/x/o: ]F`               | Same    |                                                                       |
| Go to the next Treesitter argument end           | `n/x/o: ]A`                  | `n/x/o: ]A`               | Same    |                                                                       |
| Go to the previous Treesitter block start        | `n/x/o: [k`                  | `n/x/o: [k`               | Same    |                                                                       |
| Go to the previous Treesitter function start     | `n/x/o: [f`                  | `n/x/o: [f`               | Same    |                                                                       |
| Go to the previous Treesitter argument start     | `n/x/o: [a`                  | `n/x/o: [a`               | Same    |                                                                       |
| Go to the previous Treesitter block end          | `n/x/o: [K`                  | `n/x/o: [K`               | Same    |                                                                       |
| Go to the previous Treesitter function end       | `n/x/o: [F`                  | `n/x/o: [F`               | Same    |                                                                       |
| Go to the previous Treesitter argument end       | `n/x/o: [A`                  | `n/x/o: [A`               | Same    |                                                                       |
| Swap with the next Treesitter block              | `n: >K`                      | `n: >K`                   | Same    |                                                                       |
| Swap with the next Treesitter function           | `n: >F`                      | `n: >F`                   | Same    |                                                                       |
| Swap with the next Treesitter argument           | `n: >A`                      | `n: >A`                   | Same    |                                                                       |
| Swap with the previous Treesitter block          | `n: <K`                      | `n: <K`                   | Same    |                                                                       |
| Swap with the previous Treesitter function       | `n: <F`                      | `n: <F`                   | Same    |                                                                       |
| Swap with the previous Treesitter argument       | `n: <A`                      | `n: <A`                   | Same    |                                                                       |
| Start incremental Treesitter selection           | `n: gnn`                     | —                         | Removed | +a as `n: \` through `treesitter-modules.nvim`.                            |
| Expand incremental Treesitter selection by node  | `x: grn`                     | —                         | Removed | +a as `x: \` through `treesitter-modules.nvim`.                            |
| Expand incremental Treesitter selection by scope | `x: grc`                     | —                         | Removed |                                                                       |
| Shrink incremental Treesitter selection by node  | `x: grm`                     | —                         | Removed | +a as `x: <BS>`; leave scope expansion disabled.                            |

## Yanky

| Functionality                           | NvChad key | AstroNvim key                      | State   | Note |
| --------------------------------------- | ---------- | ---------------------------------- | ------- | ---- |
| Put after with Yanky                    | `n/x: p`   | `n/x: p` with native Vim behavior  | Changed |      |
| Put before with Yanky                   | `n/x: P`   | `n/x: P` with native Vim behavior  | Changed |      |
| Grand put after with Yanky              | `n/x: gp`  | `n/x: gp` with native Vim behavior | Changed |      |
| Grand put before with Yanky             | `n/x: gP`  | `n/x: gP` with native Vim behavior | Changed |      |
| Select the previous Yanky history entry | `n: <A-k>` | —                                  | Removed |      |
| Select the next Yanky history entry     | `n: <A-j>` | —                                  | Removed |      |

## Substitute

| Functionality                     | NvChad key          | AstroNvim key       | State | Note |
| --------------------------------- | ------------------- | ------------------- | ----- | ---- |
| Start the substitute operator     | `n: m`              | `n: m`              | Same  |      |
| Substitute the current line       | `n: mm`             | `n: mm`             | Same  |      |
| Substitute to the end of the line | `n: M`              | `n: M`              | Same  |      |
| Substitute a visual selection     | `x: m`              | `x: m`              | Same  |      |
| Start the exchange operator       | `n: mx`             | `n: mx`             | Same  |      |
| Exchange the current line         | `n: mxx`            | `n: mxx`            | Same  |      |
| Exchange a visual selection       | `x: X`              | `x: X`              | Same  |      |
| Cancel an exchange operation      | `n: mxc`            | `n: mxc`            | Same  |      |
| Use the native `m` mark command   | `n/o/x: <leader>mm` | `n/o/x: <leader>mm` | Same  |      |

## Flash

| Functionality                | NvChad key | AstroNvim key | State | Note |
| ---------------------------- | ---------- | ------------- | ----- | ---- |
| Jump with Flash              | `n/o/x: s` | `n/o/x: s`    | Same  |      |
| Select with Flash Treesitter | `n/o/x: S` | `n/o/x: S`    | Same  |      |
| Run remote Flash             | `o: r`     | `o: r`        | Same  |      |
| Search with Flash Treesitter | `o/x: R`   | `o/x: R`      | Same  |      |
| Toggle Flash search          | `c: <C-S>` | `c: <C-S>`    | Same  |      |

## Surround and comments

| Functionality                         | NvChad key            | AstroNvim key         | State      | Note                                                              |
| ------------------------------------- | --------------------- | --------------------- | ---------- | ----------------------------------------------------------------- |
| Add a surrounding pair                | `n: ys{motion}{char}` | `n: ys{motion}{char}` | Same       |                                                                   |
| Delete a surrounding pair             | `n: ds{char}`         | `n: ds{char}`         | Same       |                                                                   |
| Change a surrounding pair             | `n: cs{old}{new}`     | `n: cs{old}{new}`     | Same       |                                                                   |
| Toggle a comment on the current line  | `n: <leader>/`        | `n: <leader>/`        | Unverified | NvChad stock mapping is not present in the tracked custom source. |
| Toggle comments on a visual selection | `v: <leader>/`        | `v: <leader>/`        | Unverified | NvChad stock mapping is not present in the tracked custom source. |
| Add a commented line below            | —                     | `n: gco`              | New        |                                                                   |
| Add a commented line above            | —                     | `n: gcO`              | New        |                                                                   |

## Buffer management

| Functionality                                | NvChad key | AstroNvim key    | State | Note |
| -------------------------------------------- | ---------- | ---------------- | ----- | ---- |
| Select a buffer from the tabline             | —          | `n: <leader>bb`  | New   |      |
| Close a buffer from the tabline              | —          | `n: <leader>bd`  | New   |      |
| Close all buffers except the current buffer  | —          | `n: <leader>bc`  | New   |      |
| Close all buffers                            | —          | `n: <leader>bC`  | New   |      |
| Close all buffers to the left                | —          | `n: <leader>bl`  | New   |      |
| Close all buffers to the right               | —          | `n: <leader>br`  | New   |      |
| Open the previous buffer                     | —          | `n: <leader>bp`  | New   |      |
| Open a selected buffer in a vertical split   | —          | `n: <leader>b\|` | New   |      |
| Open a selected buffer in a horizontal split | —          | `n: <leader>b\`  | New   |      |
| Go to the next buffer                        | —          | `n: ]b`          | New   | Use `<Tab>`; disable `]b` and accept the `<C-I>` tradeoff. |
| Go to the previous buffer                    | —          | `n: [b`          | New   | Use `<S-Tab>`; disable `[b`.                              |
| Move the current buffer tab right            | —          | `n: >b`          | New   |      |
| Move the current buffer tab left             | —          | `n: <b`          | New   |      |
| Sort buffers by extension                    | —          | `n: <leader>bse` | New   |      |
| Sort buffers by relative path                | —          | `n: <leader>bsr` | New   |      |
| Sort buffers by full path                    | —          | `n: <leader>bsp` | New   |      |
| Sort buffers by buffer number                | —          | `n: <leader>bsi` | New   |      |
| Sort buffers by modification state           | —          | `n: <leader>bsm` | New   |      |

## Terminal

| Functionality                                        | NvChad key         | AstroNvim key   | State   | Note                                                                            |
| ---------------------------------------------------- | ------------------ | --------------- | ------- | ------------------------------------------------------------------------------- |
| Toggle a horizontal terminal                         | —                  | `n: <leader>th` | New     |                                                                                 |
| Toggle a vertical terminal                           | —                  | `n: <leader>tv` | New     |                                                                                 |
| Toggle a floating terminal                           | —                  | `n: <leader>tf` | New     |                                                                                 |
| Toggle a Lazygit terminal                            | —                  | `n: <leader>tl` | New     |                                                                                 |
| Toggle a Node.js terminal                            | —                  | `n: <leader>tn` | New     |                                                                                 |
| Toggle a Python terminal                             | —                  | `n: <leader>tp` | New     |                                                                                 |
| Toggle a `gdu` terminal                              | —                  | `n: <leader>tu` | New     |                                                                                 |
| Toggle the default terminal                          | —                  | `n/i/t: <F7>`   | New     |                                                                                 |
| Toggle the default terminal with Control-apostrophe  | —                  | `n/i/t: <C-'>`  | New     |                                                                                 |
| Move from a terminal to the left split or tmux pane  | `t: <C-H>` in tmux | `t: <C-H>`      | Changed | AstroNvim also supports this outside tmux; vim-tmux-navigator wins inside tmux. |
| Move from a terminal to the lower split or tmux pane | `t: <C-J>` in tmux | `t: <C-J>`      | Changed | AstroNvim also supports this outside tmux; vim-tmux-navigator wins inside tmux. |
| Move from a terminal to the upper split or tmux pane | `t: <C-K>` in tmux | `t: <C-K>`      | Changed | AstroNvim also supports this outside tmux; vim-tmux-navigator wins inside tmux. |
| Move from a terminal to the right split or tmux pane | `t: <C-L>` in tmux | `t: <C-L>`      | Changed | AstroNvim also supports this outside tmux; vim-tmux-navigator wins inside tmux. |

## Splits, tabs, quickfix, and location lists

| Functionality                                    | NvChad key | AstroNvim key   | State | Note                                             |
| ------------------------------------------------ | ---------- | --------------- | ----- | ------------------------------------------------ |
| Create a horizontal split                        | —          | `n: \`          | New   | -a; `\` is reserved for incremental selection.    |
| Create a vertical split                          | —          | `n: \|`         | New   |                                                  |
| Move to the left Neovim split or tmux pane       | `n: <C-H>` | `n: <C-H>`      | Same  | Provided by vim-tmux-navigator after `VeryLazy`. |
| Move to the lower Neovim split or tmux pane      | `n: <C-J>` | `n: <C-J>`      | Same  | Provided by vim-tmux-navigator after `VeryLazy`. |
| Move to the upper Neovim split or tmux pane      | `n: <C-K>` | `n: <C-K>`      | Same  | Provided by vim-tmux-navigator after `VeryLazy`. |
| Move to the right Neovim split or tmux pane      | `n: <C-L>` | `n: <C-L>`      | Same  | Provided by vim-tmux-navigator after `VeryLazy`. |
| Return to the previous Neovim split or tmux pane | `n: <C-\>` | `n: <C-\>`      | Same  | Provided by vim-tmux-navigator after `VeryLazy`. |
| Resize a split upward                            | —          | `n: <C-Up>`     | New   |                                                  |
| Resize a split downward                          | —          | `n: <C-Down>`   | New   |                                                  |
| Resize a split to the left                       | —          | `n: <C-Left>`   | New   |                                                  |
| Resize a split to the right                      | —          | `n: <C-Right>`  | New   |                                                  |
| Go to the next tab                               | —          | `n: ]t`         | New   |                                                  |
| Go to the previous tab                           | —          | `n: [t`         | New   |                                                  |
| Open the quickfix list                           | —          | `n: <leader>xq` | New   |                                                  |
| Open the location list                           | —          | `n: <leader>xl` | New   |                                                  |

## UI toggles

| Functionality                      | NvChad key | AstroNvim key    | State | Note |
| ---------------------------------- | ---------- | ---------------- | ----- | ---- |
| Toggle the tabline                 | —          | `n: <leader>ut`  | New   |      |
| Toggle diagnostics                 | —          | `n: <leader>ud`  | New   |      |
| Toggle URL highlighting            | —          | `n: <leader>uu`  | New   |      |
| Toggle spell checking              | —          | `n: <leader>us`  | New   |      |
| Toggle line wrapping               | —          | `n: <leader>uw`  | New   |      |
| Toggle diagnostic virtual text     | —          | `n: <leader>uv`  | New   |      |
| Toggle diagnostic virtual lines    | —          | `n: <leader>uV`  | New   |      |
| Toggle automatic pairs             | —          | `n: <leader>ua`  | New   |      |
| Toggle global completion           | —          | `n: <leader>uC`  | New   |      |
| Toggle buffer completion           | —          | `n: <leader>uc`  | New   |      |
| Toggle indentation guides          | —          | `n: <leader>u\|` | New   |      |
| Toggle automatic directory changes | —          | `n: <leader>uA`  | New   |      |
| Toggle the background color mode   | —          | `n: <leader>ub`  | New   |      |
| Change line-number behavior        | —          | `n: <leader>un`  | New   |      |
| Toggle the fold column             | —          | `n: <leader>u>`  | New   |      |
| Toggle the sign column             | —          | `n: <leader>ug`  | New   |      |
| Toggle color highlighting          | —          | `n: <leader>uz`  | New   |      |
| Toggle notifications               | —          | `n: <leader>uN`  | New   |      |
| Dismiss notifications              | —          | `n: <leader>uD`  | New   |      |
| Toggle the status line             | —          | `n: <leader>ul`  | New   |      |
| Toggle Zen mode                    | —          | `n: <leader>uZ`  | New   |      |
| Toggle syntax highlighting         | —          | `n: <leader>uy`  | New   |      |
| Change indentation settings        | —          | `n: <leader>ui`  | New   |      |
| Toggle reference highlighting      | —          | `n: <leader>ur`  | New   |      |
| Toggle paste mode                  | —          | `n: <leader>up`  | New   |      |
| Toggle concealment                 | —          | `n: <leader>uS`  | New   |      | )
 ( a(b(c(d)c)b)a)

## Plugin management
Disable all below
| Functionality                  | NvChad key | AstroNvim key   | State | Note |
| ------------------------------ | ---------- | --------------- | ----- | ---- |
| Install plugins                | —          | `n: <leader>pi` | New   | -a   |
| Show plugin status             | —          | `n: <leader>ps` | New   | -a   |
| Synchronize plugins            | —          | `n: <leader>pS` | New   | -a   |
| Check for plugin updates       | —          | `n: <leader>pu` | New   | -a   |
| Update plugins                 | —          | `n: <leader>pU` | New   | -a   |
| Open Mason Installer           | —          | `n: <leader>pm` | New   | -a   |
| Update Mason packages          | —          | `n: <leader>pM` | New   | -a   |
| Update Lazy and Mason packages | —          | `n: <leader>pa` | New   | -a   |
