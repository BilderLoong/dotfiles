local none_ls = require "none-ls"

local fmt = none_ls.builtins.formatting
local lint = none_ls.builtins.diagnostics
local ca = none_ls.builtins.code_actions

local sources = {
  -- web developement
  -- fmt.prettier.with {
  --   -- milliseconds
  --   timeout = 10000,
  -- },
  fmt.prettierd.with {
    timeout = 10000,
  },

  ca.eslint_d.with {
    method = none_ls.methods.DIAGNOSTICS_ON_SAVE,
  },
  -- ca.eslint,

  ca.gitrebase,

  fmt.stylua,

  -- shell
  lint.shellcheck.with {
    extra_filetypes = { "sh", "zsh" },
  },

  fmt.shfmt.with { extra_filetypes = { "sh", "zsh" } }, -- python fmt.black.with { extra_args = { "--fast" } }, lint.ruff,

  -- misc
  -- null_ls.builtins.diagnostics.cspell,
  -- null_ls.builtins.code_actions.cspell,
}

none_ls.setup {
  debug = false,
  sources = sources,
  debounce = 500,
}
