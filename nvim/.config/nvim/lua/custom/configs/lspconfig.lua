local configs = require "plugins.configs.lspconfig"
local lspconfig = require "lspconfig"

local on_attach = configs.on_attach
local capabilities = configs.capabilities

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
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.kotlin_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- -- https://ast-grep.github.io/guide/editor-integration.html#nvim-lspconfig
-- lspconfig.ast_grep.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   default_config = {
--     cmd = { "sg", "lsp" },
--     -- filetypes = {'typescript'};
--     single_file_support = true,
--     root_dir = lspconfig.util.root_pattern(".git", "sgconfig.yml"),
--   },
-- }

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

lspconfig.jdtls.setup {

  on_attach = on_attach,
  capabilities = capabilities,
}
