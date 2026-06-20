local M = {}

function M.getTableKeys(tab)
  local keyset = {}
  for k, _ in pairs(tab) do
    keyset[#keyset + 1] = k
  end
  return keyset
end

function M.isParentPath(parentPath, childPath)
  local parentComponents = {}
  local childComponents = {}
  for component in parentPath:gmatch("[^/]+") do
    table.insert(parentComponents, component)
  end
  for component in childPath:gmatch("[^/]+") do
    table.insert(childComponents, component)
  end
  if #parentComponents > #childComponents then return false end
  for i, component in ipairs(parentComponents) do
    if component ~= childComponents[i] then return false end
  end
  return true
end

function M.reload_theme(name)
  vim.g.nvchad_theme = name
  require("base46").load_all_highlights()
  vim.api.nvim_exec_autocmds("User", { pattern = "NvChadThemeReload" })
end

function M.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

return M
