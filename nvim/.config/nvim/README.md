Use conform to format file by using lsp and external formatters.

## Custom commands

Personal Neovim commands belong in `custom/lua/user_custom/`. Register them through
the local `user-custom` plugin and add each public command name to `cmd` in
`lua/plugins/custom.lua`. Do not place new personal command definitions in
`polish.lua` or unrelated plugin specs. Load helpers on demand. Give automatic
actions their own suitable event/startup loading.

- `:CopyLocation` copies the absolute path, line, and byte column, for example
  `/Users/birudo/Projects/app/main.ts:42:8`.
- `:CopyRelativeLocation` copies the path relative to the current window working
  directory, for example `main.ts:42:8` when that directory is `app`.
- `user-custom` loads on command use (or argument completion), not command-name
  listing. See [custom/README.md](custom/README.md) for loading rules and picker use.

## GitHub links

`vim-fugitive` loads on its existing commands and `fugitive` filetype.
Its `vim-rhubarb` dependency adds GitHub support to `GBrowse` (not `Gbrowser`).

| Command | Result |
| --- | --- |
| `:GBrowse` | Open the remote location in a browser. |
| `:GBrowse!` | Copy the remote URL instead of opening it. |
| `:.GBrowse!` | Copy the current line at a fixed commit. |
| `:10,20GBrowse!` | Copy lines 10–20 at a fixed commit. |

For a visual selection, select the lines, then type `:GBrowse!`; Neovim adds the
selected range. GitHub links need published commits and suitable access. These
commands do not upload uncommitted changes.
