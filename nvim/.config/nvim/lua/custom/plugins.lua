local BufEnterLike = { "BufReadPost", "BufAdd", "BufNewFile" }
local utils = require "custom.utils"
local load_mappings = require("core.utils").load_mappings
require()

---@type NvPluginSpec[]
local plugins = {
  {
    "unblevable/quick-scope",
    event = "BufReadPost",
    config = function()
      vim.cmd [[
			  highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
			  highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline
   ]]
    end,
  },

  {
    "ggandor/lightspeed.nvim",
    event = BufEnterLike,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    keys = { "c", "y", "d" },
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "wellle/targets.vim",
    event = "BufReadPost",
  },

  {
    "elijahmanor/export-to-vscode.nvim",
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = BufEnterLike,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  {
    "mfussenegger/nvim-treehopper",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    -- keys = { "v", "y", "d", "c" },
    config = function(_, opts)
      require("core.utils").load_mappings "nvim_treehopper"
    end,
  },

  {
    "RRethy/nvim-treesitter-textsubjects",
    event = BufEnterLike,
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        textsubjects = {
          enable = true,
          prev_selection = ",", -- (Optional) keymap to select the previous selection
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },
      }
    end,
  },

  {
    "nvim-treesitter/playground",
    event = BufEnterLike,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      return require "custom.configs.treesitter"
    end,
  },

  {
    "numToStr/Comment.nvim",
    opts = function()
      -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnlvim
      return { pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle" },
  },

  {
    "Pocco81/auto-save.nvim",
    event = "BufWritePre",
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",
        "luacheck",

        -- Web
        "html-lsp",
        "typescript-language-server",
        "prettierd",
        "prettier",
        "eslint_d",
        "js-debug-adapter",
        "json-lsp",
        "css-lsp",

        -- MP
        "yaml-language-server",

        -- Shell
        "shellcheck",
        "shfmt",
        "bash-language-server",

        -- Go
        "gopls",
        "gospel",

        -- Python
        "ruff",  -- linter
        "black", -- formater

        -- Haskell
        "haskell-debug-adapter",
        "haskell-language-server",
        "fourmolu",

        -- Misc
        "cspell",
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "romgrk/nvim-treesitter-context",
    event = BufEnterLike,
    config = function()
      require("treesitter-context").setup {
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = {
          -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = { "class", "function", "method" },
        },
      }
    end,
  },
  {
    "nanotee/zoxide.vim",
    cmd = { "Z", "Tzi", "Lzi", "Zi", "Lz" },
    dependencies = {
      {
        "junegunn/fzf.vim",
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup {
        -- https://github.com/ibhagwan/fzf-lua/wiki#how-do-i-change-the-window-size-and-position
        winopts = {
          width = 0.98,
          height = 0.98,
        },
      }
    end,
  },
  {
    "junegunn/fzf.vim",
    dependencies = {
      {
        "junegunn/fzf",
        build = "./install --all",
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    opts = function()
      return {
        enhanced_diff_hl = true,
        vim.opt.fillchars:append { diff = "╱" }
      }
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    opts = function()
      local defaults = require("plugins.configs.others").gitsigns
      local custom = {
        -- stylua: ignore start
        signs = {
          add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
          change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
          delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          changedelete = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        },
        -- stylua: ignore end

        word_diff = false,
        current_line_blame = true,
        numhl = true,   -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      }

      return vim.tbl_deep_extend("force", defaults, custom)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require "cmp"
      local opts = vim.tbl_deep_extend("force", require "plugins.configs.cmp", {
        mapping = {
          ["<A-Space>"] = cmp.mapping.complete(),
        },
      })

      return opts
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        -- dependency for better sorting performance
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension "fzf"
        end,
      },

      {
        "Marskey/telescope-sg",
        config = function()
          require("telescope").load_extension "ast_grep"
        end,
      },

      {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
          require("telescope").load_extension "frecency"
        end,
        dependencies = { "kkharji/sqlite.lua" },
      },
    },
  },

  {
    "rmagatti/auto-session",
    lazy = false,
    cmd = {
      "Autosession",
      "SessionDelete",
      "SessionRestore",
      "SessionRestoreFromFile",
      "SessionSave",
    },
    opts = {
      log_level = vim.log.levels.ERROR,
      -- auto_session_enable_last_session = true,

      -- ⚠️ This will only work if Telescope.nvim is installed
      -- The following are already the default values, no need to provide them if these are already the settings you want.
      session_lens = {
        -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = true,
      },
      -- https://github.com/rmagatti/auto-session#-command-hooks
      -- https://www.reddit.com/r/neovim/comments/15bfz5f/how_to_open_nvim_tree_afjer_restoring_a_session/
      pre_save_cmds = {
        -- Doesn't support `:h lua-heredoc` here.
        "lua if vim.fn.exists(':NvimTreeClose') then vim.cmd('tabdo NvimTreeClose') end",
        "lua if vim.fn.exists(':DiffviewClose') then vim.cmd('tabdo DiffviewClose') end",
      },
    },
    config = function(_, opts)
      require("auto-session").setup(opts)
      --[For a better experience with the plugin overall using this config for sessionoptions is recommended.](https://github.com/rmagatti/auto-session#recommended-sessionoptions-config)
      --
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
  },
  {

    "nvim-tree/nvim-tree.lua",
    opts = function()
      return vim.tbl_deep_extend("force", require "plugins.configs.nvimtree", {
        filesystem_watchers = {
          --- I get a filesystem_watchers related error when compiling project, disable it help to resolve the error.
          enable = false,
        },
      })
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    init = function()
      -- Write all buffers before navigating from Vim to tmux pane
      vim.g.tmux_navigator_save_on_switch = 2
    end,
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  -- https://github.com/jimcornmell/lvim/blob/34ee4560c05f061055cddc608d882906780e7aad/config.lua#L364
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    ft = { "fugitive" },
  },

  {
    "rafcamlet/nvim-luapad",
    cmd = {
      "Luapad",
      "LuaRun",
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup {}
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons",     -- optional
    },
  },

  -- Example: https://github.com/akinsho/dotfiles/blob/d061b48766de8da969dfcb178ff32324f76aed6f/.config/nvim/lua/as/plugins/debugger.lua#L96
  -- {
  --   "mxsdev/nvim-dap-vscode-js",
  --   ft = { "javascript", "javascriptreact", "typescript", "typecriptreact" },
  --   dependencies = { "mfussenegger/nvim-dap" },
  --   opts = function(_, default_nvchad_opts)
  --     return {
  --       node_path = "node",
  --       debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  --       adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
  --     }
  --   end,
  --   config = function(_, opts)
  --     vim.print "Can't be printed."
  --     require("dap-vscode-js").setup(opts)
  --     for _, language in ipairs { "typescript", "javascript" } do
  --       print "asdfasd"
  --       require("dap").configurations--[[ [language] ]] = {
  --         {
  --           type = "pwa-node",
  --           request = "attach",
  --           name = "Attach",
  --           processId = require("dap.utils").pick_process,
  --           cwd = "${workspaceFolder}",
  --         },
  --         {
  --           -- use nvim-dap-vscode-js's pwa-node debug adapter
  --           type = "pwa-node",
  --           -- launch a new process to attach the debugger to
  --           request = "launch",
  --           -- name of the debug action you have to select for this config
  --           name = "Launch current file in new node process(" .. language .. ")",
  --           program = "${file}",
  --           cwd = "${workspaceFolder}",
  --         },
  --       }
  --     end
  --   end,
  -- },

  {
    -- https://github.com/mfussenegger/nvim-dap
    "mfussenegger/nvim-dap",
    keys = utils.getTableKeys(require("custom.mappings").debug.n),
    dependencies = {
      -- UI related https://github.com/mfussenegger/nvim-dap#goals
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = { handlers = {} },
      },
    },
    config = function(_, opts)
      require("dapui").setup()

      require("custom.configs.debug").setup()
      require("core.utils").load_mappings "debug"
    end,
  },

  {
    "jbyuki/one-small-step-for-vimkind",
    -- event = BufEnterLike,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = 'python'
  },

  {
    "folke/neodev.nvim",
    ft = 'lua',
    opts = {}
  },

  -- {
  --   "rmagatti/session-lens",
  --   dependencies = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
  --   config = function()
  --     require("session-lens").setup {
  --       prompt_title = "YEAH SESSIONS",
  --     }
  --   end,
  -- },

  {
    "LunarVim/bigfile.nvim",
    cmd = "BufReadPre",
    opts = function(_, opts)
      return {
        pattern = function(bufnr, filesize_mib)
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))

          if not ok or not stats then
            return true
          end

          local buf_size = stats.size
          -- Disable oneline file that lager than 100KB.
          local is_big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and buf_size > 100 * 1024

          return is_big_oneliner or buf_size > 2000 * 1024

          -- you can't use `nvim_buf_line_count` because this runs on BufReadPre
          -- local file_contents = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
          -- local file_length = #file_contents
          -- local filetype = vim.filetype.match { buf = bufnr }
          -- if file_length == 1 then
          --   return true
          -- end
        end,
      }
    end,
  },

  {
    "b0o/schemastore.nvim",
    filetype = { "json", "jsonc" },
    dependencies = { "neovim/nvim-lspconfig" },
  },

  -- https://github.com/mrcjkb/haskell-tools.nvim
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- Optional
    },
    branch = "2.x.x",                  -- Recommended
    init = function()                  -- Optional, see Advanced configuration
    end,
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  },

  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = "kevinhwang91/promise-async",
    -- My experience use LSP as folder provider is better than treesitter.
    -- opts = function()
    --   return {
    --     provider_selector = function(bufnr, filetype, buftype)
    --       return { "treesitter", "indent" }
    --     end,
    --   }
    -- end,

    config = function(_, opts)
      -- https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup()
      load_mappings "nvim_ufo"
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function()
      return vim.tbl_deep_extend("force", require("plugins.configs.others").blankline, {
        -- show_current_context = true,
        -- show_current_context_start = true,
        show_current_context = false,
        show_current_context_start = false,
      })
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPre" },
    version = "*",
    config = true,
  },
}


return plugins
