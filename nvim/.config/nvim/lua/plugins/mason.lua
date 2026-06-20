return {
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
        "js-debug-adapter",
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

        -- Go (gopls needs go >= 1.26, user has 1.23 — skip for now)
        -- "gopls",
        -- "gospel",

        -- Haskell
        -- "haskell-debug-adapter",
        "haskell-language-server",
        "fourmolu",

        -- Rust
        "rust-analyzer",
        "codelldb",

        -- Java
        "jdtls",

        -- Misc
        "codespell",
        "tree-sitter-cli",
      },
    },
  },
}
