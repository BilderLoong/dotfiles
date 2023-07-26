local configs = require("plugins.configs.lspconfig")
local lspconfig = require "lspconfig"
lspconfig.tsserver.setup{
  on_attach = on_attach,
    capabilities = capabilities,

}

local on_attach = configs.on_attach
local capabilities = configs.capabilities
local servers = { "html", "cssls", "clangd","tsserver"}
for _, lsp in ipairs(servers) do
  print('lsp',lsp)
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

