## ADDED Requirements

### Requirement: All vim.cmd keymap blocks SHALL be converted to Lua
All `vim.cmd` blocks that define keymaps (LSP, folder, UI sections) SHALL be rewritten as `vim.keymap.set` calls with explicit `desc`.

#### Scenario: LSP keymaps converted
- **WHEN** the config is loaded
- **THEN** `gy`, `gc`, `gcc` keymaps are defined via `vim.keymap.set` with `desc`

#### Scenario: Folder keymaps converted
- **WHEN** the config is loaded
- **THEN** `zc`, `zo`, `zC`, `zO` keymaps are defined via `vim.keymap.set` with `desc`

#### Scenario: UI navigation keymaps converted
- **WHEN** the config is loaded
- **THEN** `<C-j>`, `<C-k>`, `<C-h>`, `<C-l>` keymaps are defined via `vim.keymap.set` with `desc`

### Requirement: All existing vim.keymap.set calls SHALL have desc
Every `vim.keymap.set` call in the config that currently lacks `desc` SHALL have a `desc` option added.

#### Scenario: Leader and utility keymaps have desc
- **WHEN** the config is loaded
- **THEN** `<Space>`, `gr`, `<Leader>fs`, `<Leader>fm`, `<C-n>`, `<C-m>`, `<M-Space>`, `<Leader>d`, `<Leader>e`, `]c`, `[c`, `>>`, `<<` all have `desc`

### Requirement: All vscode-neovim defaults SHALL be overridden with desc
A `vscode_overrides()` function SHALL override all keybindings from vscode-neovim's `runtime/vscode/overrides/` directory using `vim.keymap.set` with explicit `desc`.

#### Scenario: Code action overrides
- **WHEN** the config is loaded
- **THEN** `K`, `gh`, `gd`, `gf`, `<C-]>`, `gO`, `gF`, `gD`, `gH`, `<C-w>gd`, `<C-w>gf`, `z=` are overridden with `desc`

#### Scenario: File command overrides
- **WHEN** the config is loaded
- **THEN** `ZZ`, `ZQ` are overridden with `desc`

#### Scenario: Jumplist overrides
- **WHEN** the config is loaded
- **THEN** `<C-o>`, `<C-t>`, `<C-i>`, `Tab` are overridden with `desc`

#### Scenario: Motion overrides
- **WHEN** the config is loaded
- **THEN** `g0`, `g$`, `gk`, `gj` are overridden with `desc`

#### Scenario: Scrolling overrides
- **WHEN** the config is loaded
- **THEN** `z<CR>`, `zt`, `z.`, `zz`, `z-`, `zb`, `H`, `M`, `L` are overridden with `desc`

#### Scenario: Tab command overrides
- **WHEN** the config is loaded
- **THEN** `gt` (with count support), `gT` are overridden with `desc`

#### Scenario: Window command overrides
- **WHEN** the config is loaded
- **THEN** `<C-w>s`, `<C-w>v`, `<C-w>c`, `<C-w>q`, `<C-w>o`, `<C-w>n`, `<C-w>=`, `<C-w>_`, `<C-w>w`, `<C-w>W`, `<C-w>t`, `<C-w>b`, `<C-w>j`, `<C-w>k`, `<C-w>h`, `<C-w>l`, `<C-w><C-j>`, `<C-w><C-k>`, `<C-w><C-h>`, `<C-w><C-l>`, `<C-w>+`, `<C-w>-`, `<C-w>>`, `<C-w><` are overridden with `desc`

### Requirement: Cheatsheet SHALL show all keymaps
The `<Leader>?` cheatsheet SHALL display all keymaps with their `desc`, grouped by mode.

#### Scenario: User opens cheatsheet
- **WHEN** user presses `<Leader>?`
- **THEN** a VSCode virtual document opens showing all keymaps with descriptions in markdown tables grouped by mode
