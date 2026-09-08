local M = {}

local function copy_location(modifier)
  local location = vim.fn.expand("%:" .. modifier) .. ":" .. vim.fn.line "." .. ":" .. vim.fn.col "."
  vim.fn.setreg("+", location)
end

function M.setup()
  vim.api.nvim_create_user_command("CopyLocation", function() copy_location "p" end, {
    desc = "Copy absolute file path, line, and byte column",
  })
  vim.api.nvim_create_user_command("CopyRelativeLocation", function() copy_location "." end, {
    desc = "Copy cwd-relative file path, line, and byte column",
  })
end

return M
