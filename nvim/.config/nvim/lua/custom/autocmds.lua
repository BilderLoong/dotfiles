local utils = require "custom.utils"

-- Auto save all buffer when buffer losing focus.
local api = vim.api
api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  pattern = "*",
  callback = function(ctx)
    api.nvim_command "silent! wall"

    if vim.log.levels.TRACE then
      -- vim.print("Save all buffers on blur.")
    end
  end,
})

function disable_auto_save()
  local cur_buf_name = vim.api.nvim_buf_get_name(0)
  local config_dir = vim.fn.stdpath "config"
  if utils.
  vim.g.auto_save = 0

  print('disable_auto_save')

end

api.nvim_create_autocmd({
  "BufEnter",
}, {
  callback = disable_auto_save,
})
