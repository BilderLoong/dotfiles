local configs = require("plugins.configs.lspconfig")
local lspconfig = require("lspconfig")

vim.print(require(lspconfig.lspconfig.util.lua))

local on_attach = configs.on_attach
local capabilities = configs.capabilities
local servers = { "html", "cssls", "clangd", "tsserver", "pyright", "bashls" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
