local M = {}

function M.start_tsserver()
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

function M.start_go()
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

local clients = vim.lsp.get_active_clients()
vim.print(#clients)

return M

