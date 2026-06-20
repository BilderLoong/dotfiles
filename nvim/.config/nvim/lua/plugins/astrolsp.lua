return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    servers = {
      "html",
      "cssls",
      "clangd",
      "ts_ls",
      "pyright",
      "bashls",
      "gopls",
      "jsonls",
      "sourcekit",
      "kotlin_language_server",
      "jdtls",
    },
    config = {
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
    },
    formatting = {
      format_on_save = false,
    },
    features = {
      signature_help = false,
      inlay_hints = false,
    },
  },
}
