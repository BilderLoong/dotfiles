local configs = require "plugins.configs.lspconfig"
local lspconfig = require "lspconfig"

lspconfig.tsserver.setup {}

local on_attach = configs.on_attach
local capabilities = configs.capabilities
local servers = { "html", "cssls", "clangd", "tsserver", "pyright" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
