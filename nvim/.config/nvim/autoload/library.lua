function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)

    table.insert(objects, vim.inspect(v))
  end

  return ...
end
