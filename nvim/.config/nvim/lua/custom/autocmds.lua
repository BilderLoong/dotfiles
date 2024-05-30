local utils = require "custom.utils"

vim.api.nvim_create_autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("MyFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_buf_get_option(args.buf, "buftype")

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.schedule(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "LazyFilePost", modeline = false })
        vim.api.nvim_del_augroup_by_name "MyFilePost"
      end, 0)
    end
  end,
})

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

local function disable_auto_save()
  local cur_buf_name = vim.api.nvim_buf_get_name(0)
  local config_dir = vim.fn.stdpath "config"
  if not utils.isParentPath(config_dir, cur_buf_name) then
    return
  end

  -- https://github.com/907th/vim-auto-save#enable-on-startup
  vim.b.auto_save = 0
end

api.nvim_create_autocmd({
  "BufEnter",
}, {
  callback = disable_auto_save,
})

local function _start_tsserver()
  --local cwd = vim.loop.cmd()
  local root_dir =
      vim.fs.dirname(vim.fs.find({ "tsconfig.json", "package.json", "jsconfig.json", ".git" }, { upward = true })[1])

  vim.print("root_dir", root_dir)

  local client = vim.lsp.start({
    name = "tsserver",
    cmd = { "typescript-language-server", "--stdio" },
    root_dir = root_dir,
  })
end

-- if vim.g.vim_did_enter then
-- 	_start_tsserver()
-- else
-- 	vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
-- 		--pattern = "*",
-- 		callback = function()
-- 			_start_tsserver()
-- 		end,
-- 	})
-- end
--
