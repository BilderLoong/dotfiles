# Personal Neovim commands

## Rule and folder roles

Personal Neovim commands belong in `custom/lua/user_custom/`. Register them through
the local `user-custom` plugin and add each public command name to `cmd` in
`lua/plugins/custom.lua`. Do not place new personal command definitions in
`polish.lua` or unrelated plugin specs. Load helpers on demand. Give automatic
actions their own suitable event/startup loading.

- `lua/plugins/custom.lua` tells lazy.nvim where this local plugin is and which
  commands load it.
- `custom/lua/user_custom/commands.lua` exports `setup()`, which defines the commands.
- Add helper or feature modules beside `commands.lua` only when needed. Use
  `require` when a feature needs them. There is no automatic file scanning.

To add a command, define it in the command module **and** add its name to the
specification's `cmd` list. For example, a future `ExampleCommand` needs both an
`nvim_create_user_command("ExampleCommand", ...)` definition and an
`"ExampleCommand"` entry in that list. No new keymap is required.

Automatic actions, such as autocmds, need a suitable event or startup trigger.
Do not make them wait for a copy command. `init.lua` and `polish.lua` do not need
changes for this plugin.

## Loading sequence

1. Startup reads the local plugin specification. lazy.nvim creates command
   placeholders for `CopyLocation` and `CopyRelativeLocation`.
2. Command-name completion and the Snacks commands picker can list those names
   without loading `user_custom.commands`.
3. First execution loads the local plugin, calls `setup()`, replaces both
   placeholders, and runs the selected command. Argument completion can also
   trigger loading; loading is not limited to execution.
4. Later calls use the registered commands without running setup again.

In `:lua Snacks.picker.commands()`, select a command to put it on the command line,
then press Enter to execute it. Selection alone does not execute the command.
The command reads the restored source file and cursor, not the picker buffer.
With the installed Snacks version, confirmation directly from picker insert mode
can move the source cursor left by one character. To keep the original column,
press Esc in the picker to leave insert mode, then Enter to select the command,
then Enter to execute it. Or type the command directly.

## Copy commands

| Command | Example output |
| --- | --- |
| `:CopyLocation` | `/Users/birudo/Projects/app/main.ts:42:8` |
| `:CopyRelativeLocation` | `main.ts:42:8` when the window working directory is `app` |

`CopyLocation` uses `expand('%:p')`; `CopyRelativeLocation` uses `expand('%:.')`.
Relative means the current window working directory, including `:lcd` changes,
not necessarily the Git root. Both append `line('.')` and `col('.')`.
Line and **byte column** start at 1. The column is not a screen/display column;
for example, the character after `é` starts at byte column 3 in UTF-8.

Both commands write to the system clipboard (`+` register). They reject unnamed
and non-file buffers with a message and leave the clipboard unchanged. A named
normal file buffer is allowed even if it has not been saved. A missing provider
or an error returned by the clipboard write is reported. The commands do not
claim success when a provider reports a failure; asynchronous provider errors
can also be shown by Neovim itself.

For GitHub URLs, use Fugitive's `GBrowse` commands, described in the
[parent README](../README.md#github-links). For example, `:.GBrowse!` copies a
current-line permalink. No personal Git URL aliases are added.
