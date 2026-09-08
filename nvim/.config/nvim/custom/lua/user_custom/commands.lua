local M = {}

local function format_location(path, buftype, line, column)
  if path == "" or buftype ~= "" then return nil, "Use a named file buffer to copy a location" end
  return path .. ":" .. line .. ":" .. column
end

local function copy_location(modifier)
  local location, err =
    format_location(vim.fn.expand("%:" .. modifier), vim.bo.buftype, vim.fn.line ".", vim.fn.col ".")
  if not location then
    vim.notify(err, vim.log.levels.WARN)
    return
  end
  if vim.fn.has "clipboard" ~= 1 then
    vim.notify("Cannot copy location: no clipboard provider", vim.log.levels.ERROR)
    return
  end
  local ok, result = pcall(vim.fn.setreg, "+", location, "v")
  if not ok or result ~= 0 then vim.notify("Cannot copy location: " .. tostring(result), vim.log.levels.ERROR) end
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
