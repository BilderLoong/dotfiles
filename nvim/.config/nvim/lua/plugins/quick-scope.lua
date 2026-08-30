return {
  "unblevable/quick-scope",
  event = "BufReadPost",
  config = function()
    vim.cmd [[
			  " highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
			  " highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline
   ]]
  end,
}
