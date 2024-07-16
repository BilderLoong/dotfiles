local configs = require "plugins.configs.lspconfig"
local lspconfig = require "lspconfig"

local on_attach = configs.on_attach
local capabilities = configs.capabilities

-- require("java").setup()

-- UFO: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "clangd",
  "tsserver",
  "pyright",
  "bashls",
  "gopls",
  "jsonls",
  "sourcekit",
  "kotlin_language_server",
  "jdtls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- https://github.com/b0o/SchemaStore.nvim#usage
lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
