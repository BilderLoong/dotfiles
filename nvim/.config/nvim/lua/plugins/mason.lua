return {
  "williamboman/mason.nvim",
  opts = {
    registries = {
      "github:nvim-java/mason-registry",
      "github:mason-org/mason-registry",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",
        "luacheck",

        -- Python
        "debugpy",
        "pyright",
        "ruff",
        "black",

        -- Web
        "html-lsp",
        "typescript-language-server",
        "prettierd",
        "eslint_d",
        "js-debug-adapter@v1.76.1",
        "json-lsp",
        "css-lsp",

        -- Kotlin
        "ktlint",
        "kotlin-language-server",
        "kotlin-debug-adapter",

        -- YAML
        "yaml-language-server",

        -- Shell
        "shellcheck",
        "shfmt",
        "bash-language-server",

        -- Go
        "gopls",
        "gospel",

        -- Haskell
        "haskell-debug-adapter",
        "haskell-language-server",
        "fourmolu",

        -- Rust
        "rust-analyzer",
        "codelldb",

        -- Java
        "jdtls",

        -- Misc
        "cspell",
        "codespell",
        "tree-sitter-cli",
      },
    },
  },
}
