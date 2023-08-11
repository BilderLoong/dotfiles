local configs = require("plugins.configs.lspconfig")
local lspconfig = require("lspconfig")

local on_attach = configs.on_attach
local capabilities = configs.capabilities
local servers = { "html", "cssls", "clangd", "tsserver", "pyright", "bashls" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	pattern = "*",
	callback = function()
		vim.print("VimEnter")
	end,
})
