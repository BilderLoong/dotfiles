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

  -- Split the parent path into its components
  for component in parentPath:gmatch "[^/]+" do
    table.insert(parentComponents, component)
  end

  -- Split the child path into its components
  for component in childPath:gmatch "[^/]+" do
    table.insert(childComponents, component)
  end

  -- Check if the parent path is a parent of the child path
  if #parentComponents > #childComponents then
    return false -- Parent path has more components, so it can't be the parent
  end

  for i, component in ipairs(parentComponents) do
    if component ~= childComponents[i] then
      return false -- Components don't match, so it's not the parent
    end
  end

  return true -- Parent path is the parent of the child path
end


return M

