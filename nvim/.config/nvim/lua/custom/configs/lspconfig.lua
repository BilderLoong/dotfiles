local configs = require "plugins.configs.lspconfig"
local lspconfig = require "lspconfig"

local on_attach = configs.on_attach
local capabilities = configs.capabilities
-- https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local servers = { "html", "cssls", "clangd", "tsserver", "pyright", "bashls", "gopls", "jsonls" }


for _, lsp in ipairs(language_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- https://ast-grep.github.io/guide/editor-integration.html#nvim-lspconfig
lspconfig.ast_grep.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  default_config = {
    cmd = { "sg", "lsp" },
    -- filetypes = {'typescript'};
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern(".git", "sgconfig.yml"),
  },
}
-- https://github.com/b0o/SchemaStore.nvim#usage
lspconfig.jsonls.setup  {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

