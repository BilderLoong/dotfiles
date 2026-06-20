return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = {
        relativenumber = true,
        foldmethod = "expr",
        foldexpr = "nvim_treesitter#foldexpr()",
        foldenable = false,
      },
      g = {
        toggle_theme_icon = "",
      },
    },
    mappings = {
      n = {
        -- Disable default mappings
        ["<leader>D"] = false,

        -- General
        ["zt"] = { "zt3<c-y>" },
        ["<leader>cd"] = {
          function() require("export-to-vscode").launch() end,
          desc = "Export to VSCode",
          noremap = true,
          silent = true,
        },
        ["<leader>cg"] = {
          function() require("custom_cmds").open_config() end,
          desc = "Open neovim config in a new tab",
          noremap = true,
          silent = true,
        },

        -- Telescope
        ["<A-d>"] = { "<cmd>Telescope lsp_document_symbols<CR>", desc = "Find document symbols" },
        ["<A-b>"] = { "<cmd>Telescope<CR>", desc = "Telescope builtins" },
        ["<A-p>"] = { "<cmd>Telescope commands<CR>", desc = "Telescope commands" },
        ["<A-r>"] = { "<cmd>Telescope resume<CR>", desc = "Resume last Telescope picker" },
        ["<leader>ss"] = {
          function() require("auto-session.session-lens").search_session() end,
          desc = "Find session history",
        },
        ["<leader>sg"] = { "<cmd>Telescope ast_grep<CR>", desc = "AST Grep" },

        -- fzf-lua
        ["<leader>rr"] = { function() require("fzf-lua").resume() end, desc = "Resume last fzf-lua search" },
        ["<leader>fs"] = { function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Find workspace symbols" },
        ["<leader>fw"] = { function() require("fzf-lua").live_grep_native() end, desc = "Live grep native" },
        ["<leader>gt"] = { function() require("fzf-lua").git_status() end, desc = "Git status" },
        ["<F1>"] = { function() require("fzf-lua").help_tags() end, desc = "Fzf lua help tags" },
        ["<C-P>"] = { function() require("fzf-lua").files { follow = true } end, desc = "Fzf-lua find files" },

        -- LSP (Glance, Lspsaga, Telescope)
        ["gy"] = { "<cmd>Glance type_definitions<CR>", desc = "Glance LSP type definitions" },
        ["gr"] = { "<cmd>Glance references<CR>", desc = "Glance LSP references" },
        ["gd"] = { "<cmd>Glance definitions<CR>", desc = "Glance LSP definitions" },
        ["gi"] = { "<cmd>Telescope lsp_implementations<CR>", desc = "Telescope LSP implementations" },
        ["gO"] = { "<cmd>Lspsaga outline<CR>", desc = "Open symbols outline" },
        ["ga"] = { "<cmd>Lspsaga finder<CR>", desc = "Show LSP methods search result" },
        ["<leader>ca"] = { "<cmd>Lspsaga code_action<CR>", desc = "Lspsaga code action" },
        ["<leader>n"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Show diagnostic in a nice float" },
        ["K"] = { "<cmd>Lspsaga hover_doc<CR>", desc = "Open hover" },

        -- Gitsigns
        ["<leader>ghu"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage Git hunk" },
        ["<leader>ghr"] = { function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
        ["<leader>ghs"] = { function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk" },

        -- UFO folding
        ["zM"] = { function() require("ufo").closeAllFolds() end, desc = "UFO close all folds" },
        ["zR"] = { function() require("ufo").openAllFolds() end, desc = "UFO open all folds" },

        -- Yanky
        ["p"] = { "<Plug>(YankyPutAfter)", desc = "Yanky put after" },
        ["P"] = { "<Plug>(YankyPutBefore)", desc = "Yanky put before" },
        ["gp"] = { "<Plug>(YankyGPutAfter)", desc = "Yanky grand put after" },
        ["gP"] = { "<Plug>(YankyGPutBefore)", desc = "Yanky grand put before" },
        ["<A-k>"] = { "<Plug>(YankyPreviousEntry)", desc = "Yanky previous entry" },
        ["<A-j>"] = { "<Plug>(YankyNextEntry)", desc = "Yanky next entry" },
      },
      i = {
        ["jk"] = { "<ESC>", desc = "Escape insert mode", nowait = true },
        ["<A-d>"] = { "<cmd>Telescope lsp_document_symbols<CR>", desc = "Find document symbols" },
        ["<A-b>"] = { "<cmd>Telescope<CR>", desc = "Telescope builtins" },
        ["<A-p>"] = { "<cmd>Telescope commands<CR>", desc = "Telescope commands" },
        ["<A-r>"] = { "<cmd>Telescope resume<CR>", desc = "Resume last Telescope picker" },
      },
      v = {
        ["zt"] = { "zt3<c-y>" },
        ["<leader>ghu"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage Git hunk" },
        ["<leader>ghr"] = { function() require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "Reset Hunk" },
        ["<leader>ghs"] = { function() require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "Stage Hunk" },
      },
      x = {
        ["p"] = { "<Plug>(YankyPutAfter)", desc = "Yanky put after" },
        ["P"] = { "<Plug>(YankyPutBefore)", desc = "Yanky put before" },
        ["gp"] = { "<Plug>(YankyGPutAfter)", desc = "Yanky grand put after" },
        ["gP"] = { "<Plug>(YankyGPutBefore)", desc = "Yanky grand put before" },
        ["ih"] = { ":<C-U>Gitsigns select_hunk<CR>", desc = "Select Hunk" },
      },
      o = {
        ["ih"] = { "<cmd>C-U>Gitsigns select_hunk<CR>", desc = "Select Hunk" },
      },
    },
    autocmds = {
      MyFilePost = {
        {
          event = { "UIEnter", "BufReadPost", "BufNewFile" },
          once = true,
          desc = "Trigger LazyFilePost event after UI enters and file opens",
          callback = function(args)
            local file = vim.api.nvim_buf_get_name(args.buf)
            local buftype = vim.bo[args.buf].buftype
            if not vim.g.ui_entered and args.event == "UIEnter" then
              vim.g.ui_entered = true
            end
            if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
              vim.schedule(function()
                vim.api.nvim_exec_autocmds("User", { pattern = "LazyFilePost", modeline = false })
                vim.api.nvim_del_augroup_by_name "MyFilePost"
              end)
            end
          end,
        },
      },
      AutoSave = {
        {
          event = { "BufLeave", "FocusLost" },
          pattern = "*",
          desc = "Auto save on focus lost",
          callback = function() vim.cmd "silent! wall" end,
        },
        {
          event = { "BufEnter" },
          desc = "Disable auto save for config files",
          callback = function()
            local cur_buf_name = vim.api.nvim_buf_get_name(0)
            local config_dir = vim.fn.stdpath "config"
            if not cur_buf_name:find(config_dir, 1, true) then return end
            vim.b.auto_save = 0
          end,
        },
      },
    },
  },
}
