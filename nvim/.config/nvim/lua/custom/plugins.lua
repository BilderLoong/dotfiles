local BufEnterLike = { "VeryLazy" }
local User_FilePost = { "User FilePost" }
local utils = require "custom.utils"
local load_mappings = require("core.utils").load_mappings

---@type NvPluginSpec[]
local plugins = {
  {
    "unblevable/quick-scope",
    event = User_FilePost,
    config = function()
      vim.cmd [[
			  highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
			  highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline
   ]]
    end,
  },

  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {},
    keys = {
      -- stylua: ignore start
      { "m",          mode = { "n", "o", "x" }, function() require("flash").jump() end,              desc = "Flash Jump" },
      { "M",          mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "<leader>mm", mode = { "n", "o", "x" }, "m",                                                 desc = "Default m key.",     { noremap = true } },
      { "r",          mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",          mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>",      mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
      -- stylua: ignore end
    },
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
    event = BufEnterLike,
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
    "RRethy/nvim-treesitter-textsubjects",
    -- event = BufEnterLike,
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
    -- event = BufEnterLike,
    event = BufEnterLike,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = BufEnterLike,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      return require "custom.configs.treesitter"
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },

  {
    "numToStr/Comment.nvim",
    opts = function()
      -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnlvim
      return { pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() }
    end,
  },

  {

    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      require "custom.configs.null-ls"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
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

        -- Python
        "debugpy", -- Debugger
        "pyright", -- LSP
        "ruff",    -- Linter
        "black",   -- Formater

        -- Web
        "html-lsp",
        "typescript-language-server",
        "prettierd",
        -- "prettier",
        "eslint_d",
        "js-debug-adapter@v1.76.1",
        "json-lsp",
        "css-lsp",

        -- Kotlin

        "ktlint",
        "kotlin-language-server",
        "kotlin-debug-adapter",

        -- MP
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

        -- java
        "jdtls",

        -- Misc
        "cspell",
      },
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  {
    "romgrk/nvim-treesitter-context",
    -- event = BufEnterLike,
    event = BufEnterLike,
    config = function()
      require("treesitter-context").setup {
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 4,   -- How many lines the window should span. Values <= 0 mean no limit.
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
        vim.opt.fillchars:append { diff = "╱" },
      }
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    opts = function(_, nvchad_defaults)
      return vim.tbl_deep_extend("force", nvchad_defaults, {
        -- stylua: ignore start
        signs = {
          add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
          change = { hl = "NONE", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
          delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          changedelete = { hl = "NONE", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        },
        -- stylua: ignore end

        word_diff = false,
        current_line_blame = true,
        numhl = false,  -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`

        current_line_blame_opts = {
          delay = 500,
          ignore_whitespace = true,
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
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
    event = "VeryLazy",
    cmd = {
      "Autosession",
      "SessionDelete",
      "SessionRestore",
      "SessionRestoreFromFile",
      "SessionSave",
    },
    opts = {
      auto_restore_enabled = false, -- auto restore seesion will block the OSV start debug server.
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
        "lua if vim.fn.exists(':NvimTreeClose') > 0 then vim.cmd('tabdo NvimTreeClose') end",
        "lua if vim.fn.exists(':DiffviewClose') > 0 then vim.cmd('tabdo DiffviewClose') end",
      },
    },
    config = function(_, opts)
      require("auto-session").setup(opts)
      -- [For a better experience with the plugin overall using this config for sessionoptions is recommended.](https://github.com/rmagatti/auto-session#recommended-sessionoptions-config)
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
      require("lspsaga").setup {
        finder = {
          max_height = 0.6,
          left_width = 0.45,
          right_width = 0.50,
          keys = {
            vsplit = "v",
            split = "s",
          },
          methods = {
            tyd = "textDocument/typeDefinition",
          },
        },

        -- Default: https://github.com/nvimdev/lspsaga.nvim/blob/ac29d673d9edc437a05cce30fce1c5b070a25664/lua/lspsaga/init.lua#L55
        lightbulb = {
          enable = false,
        },
        code_action = {
          extend_gitsigns = true,
        },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons",     -- optional
    },
  },

  -- Example: https://github.com/akinsho/dotfiles/blob/d061b48766de8da969dfcb178ff32324f76aed6f/.config/nvim/lua/as/plugins/debugger.lua#L96
  {
    "mxsdev/nvim-dap-vscode-js",
    event = "VeryLazy",
    -- ft = { "javascript", "javascriptreact", "typescript", "typecriptreact" },
    dependencies = { "mfussenegger/nvim-dap" },
    opts = function(_, default_nvchad_opts)
      return {
        -- debugger_path = vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter",
        debugger_path = "/Users/birudo/Project/vscode-js-debug",
        -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
          "node",
          "chrome",
        },
        -- log_file_path = vim.fn.stdpath("log") .. "/nvim-dap-vscode-js", -- Path for file logging
        -- log_file_level = vim.log.levels.TRACE, -- Logging level for output to file. Set to false to disable file logging.
      }
    end,
    config = function(_, opts)
      require("dap-vscode-js").setup(opts)

      for _, language in ipairs { "typescript", "javascript" } do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            -- use nvim-dap-vscode-js's pwa-node debug adapter
            type = "pwa-node",
            -- launch a new process to attach the debugger to
            request = "launch",
            -- name of the debug action you have to select for this config
            name = "Launch current file in new node process (" .. language .. ")",
            program = "${file}",
            smartStep = true,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },

  {
    -- https://github.com/mfussenegger/nvim-dap
    "mfussenegger/nvim-dap",
    keys = utils.getTableKeys(require("custom.mappings").debug.n),
    dependencies = {
      -- UI related https://github.com/mfussenegger/nvim-dap#goals
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      -- {
      -- 	"jay-babu/mason-nvim-dap.nvim",
      -- 	dependencies = { "nvim-dap" },
      -- 	cmd = { "DapInstall", "DapUninstall" },
      -- 	opts = { handlers = {} },
      -- },
    },
    config = function(_, opts)
      require("dapui").setup()

      require("custom.configs.debug").setup()
      load_mappings "debug"
    end,
  },

  {

    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      require("dapui").setup(opts)

      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end
    end,
  },

  {
    "jbyuki/one-small-step-for-vimkind",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      load_mappings "osv"
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
    config = function()
      -- TODO Maybe use a more heuristic way to decide the python path.
      require("dap-python").setup "/home/birudo/Projects/playground/.virtualenvs/debugpy/bin/python"
    end,
  },

  {
    -- Havn't verify is this plugin work properly.
    "folke/neodev.nvim",
    ft = "lua",
    dependencies = {
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
      require("neodev").setup(opts)
    end,
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
    version = "^3",                    -- Recommended
    -- init = function() -- Optional, see Advanced configuration
    -- end,
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function(_, opts)
      load_mappings "lspconfig"
      load_mappings "haskell_tools"
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    event = BufEnterLike,
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
    event = BufEnterLike,
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
    -- event = BufEnterLike,
    event = BufEnterLike,
    version = "*",
    config = true,
  },

  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "go" },
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },

  -- Make it easy to view messages.
  {
    "AckslD/messages.nvim",
    cmd = "Messages",
    config = function(_, opts)
      require("messages").setup()
    end,
  },

  {
    "github/copilot.vim",
    event = BufEnterLike,
    cmd = "Copilot ",
    config = function(_, opts)
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_proxy = "localhost:7890"
    end,
  },
  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    config = function(_, opts)
      load_mappings "lspconfig"
    end,
  },

  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
    },

    config = function()
      require("java").setup()
    end,
  },

  {
    "gbprod/yanky.nvim",
    event = { "TextYankPost" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    config = function(_, opts)
      require("yanky").setup()
      load_mappings "yanky"
    end,
  },

  {
    "gbprod/substitute.nvim",
    keys = {
      -- stylua: ignore start
      { "sx",  mode = { "n" }, function() require("substitute.exchange").operator() end, desc = "Substitute Exchange Operator", { noremap = true }, },
      { "sxx", mode = { "n" }, function() require("substitute.exchange").line() end,     desc = "Substitute Exchange Line",     { noremap = true }, },
      { "X",   mode = { "x" }, function() require("substitute.exchange").visual() end,   desc = "Substitute Exchange Visual",   { noremap = true }, },
      { "sxc", mode = { "n" }, function() require("substitute.exchange").cancel() end,   desc = "Substitute Exchange Cancel",   { noremap = true }, },
      { "s",   mode = { "n" }, function() require("substitute").operator() end,          desc = "Substitute Operator",          { noremap = true }, },
      { "ss",  mode = { "n" }, function() require("substitute").line() end,              desc = "Substitute Line",              { noremap = true }, },
      { "S",   mode = { "n" }, function() require("substitute").eol() end,               desc = "Substitute EOL",               { noremap = true }, },
      { "s",   mode = { "x" }, function() require("substitute").visual() end,            desc = "Substitute Visual",            { noremap = true }, },
      -- stylua: ignore end
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    config = function(_, opts)
      require("substitute").setup {
        on_substitute = require("yanky.integration").substitute(),
      }
    end,
  },
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    config = function(_, opts)
      require("glance").setup {
        border = {
          enable = true, -- Show window borders. Only horizontal borders allowed
        },
        use_trouble_qf = true,
      }
    end,
  },
  {
    "Tastyep/structlog.nvim",
    dependencies = {
      "rcarriga/nvim-notify",
    },
  },
  -- {
  --   "j-hui/fidget.nvim",
  --   opts = {
  --     -- options
  --   },
  -- },
  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function(_, opts)
  --     local harpoon = require "harpoon"
  --     harpoon:setup()
  --   end,
  -- },
}

return plugins
