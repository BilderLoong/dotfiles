---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
      },
    },
    mappings = {
      n = {
        -- Escape insert mode
        ["jk"] = { "<ESC>", desc = "Escape insert mode", nowait = true },

        -- Open config
        ["<leader>cg"] = {
          function() require("custom_cmds").open_config() end,
          desc = "Open neovim config",
        },

        -- Glance LSP
        ["gd"] = { "<cmd>Glance definitions<CR>", desc = "Glance definitions" },
        ["gr"] = { "<cmd>Glance references<CR>", desc = "Glance references" },
        ["gy"] = { "<cmd>Glance type_definitions<CR>", desc = "Glance type definitions" },
        ["gi"] = { "<cmd>Glance implementations<CR>", desc = "Glance implementations" },

        -- Lspsaga
        ["gO"] = { "<cmd>Lspsaga outline<CR>", desc = "Symbols outline" },
        ["ga"] = { "<cmd>Lspsaga finder<CR>", desc = "LSP finder" },
        ["K"] = { "<cmd>Lspsaga hover_doc<CR>", desc = "Hover doc" },
        ["<leader>ca"] = { "<cmd>Lspsaga code_action<CR>", desc = "Code action" },
        ["<leader>n"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next diagnostic" },

        -- Session
        ["<leader>ss"] = {
          function() require("auto-session.session-lens").search_session() end,
          desc = "Session lens",
        },

        -- Copilot accept (insert mode)
        -- Note: this is in insert mode, see below

        -- Yanky history navigation
        ["<A-k>"] = { "<Plug>(YankyPreviousEntry)", desc = "Yanky previous" },
        ["<A-j>"] = { "<Plug>(YankyNextEntry)", desc = "Yanky next" },

        -- UFO folds
        ["zM"] = { function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
        ["zR"] = { function() require("ufo").openAllFolds() end, desc = "Open all folds" },

        -- Quick find files
        ["<C-P>"] = { function() require("snacks").picker.files() end, desc = "Find files" },
      },
      i = {
        -- Copilot accept
        ["<C-J>"] = { 'copilot#Accept("<CR>")', expr = true, replace_keycodes = false, desc = "Copilot accept" },
      },
      v = {
        ["jk"] = { "<ESC>", desc = "Escape visual mode" },
      },
    },
  },
}
