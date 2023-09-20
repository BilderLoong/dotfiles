local null_ls = require("null-ls")

local fmt = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local ca = null_ls.builtins.code_actions

local sources = {
  -- web developement
  fmt.prettierd,
  -- fmt.prettier,
  -- ca.eslint_d,
  ca.eslint_d,
  ca.gitrebase,

  fmt.stylua,

  -- shell
  lint.shellcheck.with {
    extra_filetypes = { "sh", "zsh" },
  },
  fmt.shfmt.with {
    extra_filetypes = { "sh", "zsh" },
  },

  -- python
  fmt.black.with { extra_args = { "--fast" } },
  lint.ruff,

  -- misc
  -- null_ls.builtins.diagnostics.cspell,
  -- null_ls.builtins.code_actions.cspell,
}

null_ls.setup({
  debug = false,
  sources = sources,
})
