## 1. Convert vim.cmd blocks to Lua with desc

- [x] 1.1 Convert LSP `vim.cmd` block (`gy`, `gc`, `gcc`) to `vim.keymap.set` with `desc`
- [x] 1.2 Convert folder `vim.cmd` block (`zc`, `zo`, `zC`, `zO`) to `vim.keymap.set` with `desc`
- [x] 1.3 Convert UI `vim.cmd` block (`<C-j/k/h/l>`) to `vim.keymap.set` with `desc`

## 2. Add desc to existing vim.keymap.set calls

- [x] 2.1 Add `desc` to leader/utility keymaps: `<Space>`, `gr`, `<Leader>fs`, `<Leader>fm`
- [x] 2.2 Add `desc` to UI keymaps: `<C-n>`, `<C-m>`, `<M-Space>`, `<Leader>d`, `<Leader>e`
- [x] 2.3 Add `desc` to editor keymaps: `]c`, `[c`, `>>`, `<<`

## 3. Add vscode_neovim_overrides function

- [x] 3.1 Add code action overrides: `K`, `gh`, `gd`, `gf`, `<C-]>`, `gO`, `gF`, `gD`, `gH`, `<C-w>gd`, `<C-w>gf`, `z=`
- [x] 3.2 Add file command overrides: `ZZ`, `ZQ`
- [x] 3.3 Add jumplist overrides: `<C-o>`, `<C-t>`, `<C-i>`, `Tab`
- [x] 3.4 Add motion overrides: `g0`, `g$`, `gk`, `gj`
- [x] 3.5 Add scrolling overrides: `z<CR>`, `zt`, `z.`, `zz`, `z-`, `zb`, `H`, `M`, `L`
- [x] 3.6 Add tab command overrides: `gt` (with count support), `gT`
- [x] 3.7 Add window command overrides: `<C-w>` family (~24 keymaps)

## 4. Verify

- [x] 4.1 Open VSCode with vscode-neovim, press `<Leader>?`, confirm all keymaps appear with desc
