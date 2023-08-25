local M = {}

function M.getTableKeys(tab)
	local keyset = {}
	for k, _ in pairs(tab) do
		keyset[#keyset + 1] = k
	end
	return keyset
end

return M