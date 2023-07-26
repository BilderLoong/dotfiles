
local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local ca = null_ls.builtins.code_actions

local sources = {
  -- Web developement
   formatting.prettierd,
   ca.eslint_d,
  null_ls.builtins.code_actions.gitrebase,

   formatting.stylua,

   lint.shellcheck,

  -- Misc
   null_ls.builtins.diagnostics.cspell,
   null_ls.builtins.code_actions.cspell
}

null_ls.setup {
   debug = true,
   sources = sources,
}
