local BufEnterLike =  { 'BufReadPost', 'BufAdd', 'BufNewFile' }

local plugins = {
  {
  'unblevable/quick-scope',
  event = BufEnterLike,
  },
  {
    'ggandor/lightspeed.nvim',
    event = BufEnterLike,
  },
    {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    keys= {'c','y','d'},
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  {
    "wellle/targets.vim",
    event = BufEnterLike
  },
{
  "elijahmanor/export-to-vscode.nvim",
  event = BufEnterLike
  },

  {
    "RRethy/nvim-treesitter-textsubjects",
    opt = true,
    event = BufEnterLike,
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('nvim-treesitter.configs').setup {
        textsubjects = {
          enable = true,
          prev_selection = ',', -- (Optional) keymap to select the previous selection
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
          },
        },
      }
    end
  },

 {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end
  },
  {
    "nvim-treesitter/playground",
    event = BufEnterLike
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults 
        "vim",
        "lua",
        -- web dev 
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        -- "vue", "svelte",

       -- low level
        "c",
        "zig"
      },
    },
  },
  {
  "neovim/nvim-lspconfig",
   config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
   end,
},
  {
  "folke/trouble.nvim",
  cmd = "TroubleToggle",
},

  {
    "Pocco81/auto-save.nvim",
    event='VeryLazy',
    config=function ()
     require('auto-save').setup{}
    end
  }, 
  {
   "williamboman/mason.nvim",
   opts = {
      ensure_installed = {
        -- lua
        "lua-language-server",
        "stylua",
				"luacheck",

        -- Web 
        "html-lsp",
        "prettier",
        "typescript-language-server",
        "cssls",
"vuejs/vetur ",

        -- MP
        "wxml-languageserver",
        "yaml-language-server",

      },
    },
  }
}

return plugins


