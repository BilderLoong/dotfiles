local M = {}
local last_picker

function M.mark(picker) last_picker = picker end

function M.resume()
  if last_picker == "fff" then
    require("fff").resume()
  elseif last_picker == "snacks" then
    require("snacks").picker.resume()
  else
    vim.notify("No picker to resume")
  end
end

return M
