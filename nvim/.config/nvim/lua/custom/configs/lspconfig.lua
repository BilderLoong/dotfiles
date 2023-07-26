local configs = require("plugins.configs.lspconfig")
local lspconfig = require "lspconfig"

local on_attach = configs.on_attach
local capabilities = configs.capabilities
local servers = { "html", "cssls", "clangd"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
.tsserver.setup{}
