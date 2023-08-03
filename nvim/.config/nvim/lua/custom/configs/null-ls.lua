local null_ls = require "null-ls"

local fmt = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local ca = null_ls.builtins.code_actions

local sources = {
  -- Web developement
  fmt.prettierd,
  -- fmt.prettier,
  ca.eslint_d,
  ca.gitrebase,

  fmt.stylua,

  -- Shell
  lint.shellcheck,
  fmt.shfmt,

  -- Python
  fmt.black,
  lint.diagnostics.ruff

  -- Misc
  -- null_ls.builtins.diagnostics.cspell,
  -- null_ls.builtins.code_actions.cspell,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
