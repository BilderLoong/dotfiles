local configs = require "plugins.configs.lspconfig"
local lspconfig = require "lspconfig"

local on_attach = configs.on_attach
local capabilities = configs.capabilities
-- local servers = { "html", "cssls", "clangd", "tsserver", "pyright", "bashls", "gopls", "jsonls" }
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}

-- https://ast-grep.github.io/guide/editor-integration.html#nvim-lspconfig
configs.ast_grep = {
  default_config = {
    cmd = { "sg", "lsp" },
    -- filetypes = {'typescript'};
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern(".git", "sgconfig.yml"),
  },
}
-- https://github.com/b0o/SchemaStore.nvim#usage
configs.jsonls = {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

for _, lsp in ipairs(language_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
