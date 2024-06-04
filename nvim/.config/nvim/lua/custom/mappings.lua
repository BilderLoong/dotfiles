-- @type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<leader>D"] = "",
  },
}

M.general = {
  i = {
    ["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },
  },
  n = {
    ["zt"] = { "zt3<c-y>" },
    ["<leader>cd"] = {
      function()
        require("export-to-vscode").launch()
      end,
      "Export to VSCode",
      opts = { noremap = true, silent = true },
    },
    ["<leader>cg"] = {
      function()
        require("custom.custom_cmds").open_config()
      end,
      "Open neovim config in a new tab.",
      opts = { noremap = true, silent = true },
    },
  },
  v = {
    ["zt"] = { "zt3<c-y>" },
  },
}

local telescope_i_n = {
  ["<A-d>"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find document symbols" },
  ["<A-b>"] = { "<cmd> Telescope <CR>", "Telescope builtins" },
  -- ["<A-k>"] = { "<cmd> Telescope keymaps <CR>", "Telescope keymaps" },
  ["<A-p>"] = { "<cmd> Telescope commands <CR>", "Telescope commands" },
  ["<A-r>"] = { "<cmd> Telescope resume <CR>", "Resume last Telescope picker" },
  ["<F1>"] = {
    function()
      require("fzf-lua").help_tags()
    end,
    "Fzf lua help tags.",
  },
  ["<C-P>"] = {
    function()
      require("fzf-lua").files {
        follow = true,
      }
    end,
    "Fzf-lua find files.",
  },
}

M.telescope = {
  n = vim.tbl_deep_extend("force", telescope_i_n, {
    ["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find workspace symbols" },
    ["<leader>ss"] = {
      function()
        require("auto-session.session-lens").search_session()
      end,
      "Find session history.",
    },
    ["<leader>sg"] = { "<cmd> Telescope ast_grep  <CR>", "AST Grep!" },
  }),
  i = vim.tbl_deep_extend("force", telescope_i_n, {}),
}

M.fzf_lua = {
  n = {
    ["<leader>rr"] = {
      function()
        require("fzf-lua").resume()
      end,
      "Resume last fzf-lua search.",
    },
  },
}

M.lspconfig = {
  n = {
    ["gd"] = {
      "<cmd> Glance type_definitions  <CR>",
      "LSP definitions",
    },
    ["gr"] = {
      "<cmd> Glance references",
      "Telescope LSP references",
    },
    ["gy"] = {
      "<cmd> Telescope lsp_type_definitions <CR>",
      "Telescope LSP type definitions",
    },
    ["gi"] = {
      "<cmd> Telescope lsp_implementations <CR>",
      "Telescope LSP type implementations",
    },
    ["gO"] = {
      "<cmd> Lspsaga outline <CR>",
      "Open symbols outline.",
    },
    ["ga"] = {
      "<cmd> Lspsaga finder <CR>",
      "Show LSP methods search result.",
    },
    -- https://nvimdev.github.io/lspsaga/codeaction/
    ["<leader>ca"] = {
      "<cmd> Lspsaga code_action <CR>",
      "LSPsaga code action.",
    },
    -- https://nvimdev.github.io/lspsaga/diagnostic/
    ["<leader>n"] = {
      "<cmd> Lspsaga diagnostic_jump_next <CR>",
      "Show the diagnostic in a nice float.",
    },
    -- https://nvimdev.github.io/lspsaga/hover/
    -- `gx` to open link.
    ["K"] = {
      "<cmd> Lspsaga hover_doc <CR>",
      "Open hover",
    },
  },
}

M.gitsigns = {
  v = {
    ["<leader>ghu"] = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Unstage Git hunk",
    },
    ["<leader>ghr"] = {
      function()
        require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" }
      end,
      "Reset Hunk",
    },

    ["<leader>ghs"] = {
      function()
        require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" }
      end,
      "Stage Hunk",
    },
  },
  n = {
    ["<leader>ghu"] = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Unstage Git hunk",
    },
    ["<leader>ghr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset Hunk",
    },

    ["<leader>ghs"] = {
      function()
        require("gitsigns").stage_hunk()
      end,
      "Stage Hunk",
    },
  },

  -- Text object
  x = {
    ["ih"] = {
      ":<C-U>Gitsigns select_hunk <CR>",
      "Select Hunk",
    },
  },
  o = {
    ["ih"] = {
      "<cmd>C-U>Gitsigns select_hunk <CR>",
      "Select Hunk",
    },
  },
}

M.debug = {
  -- https://nvchad.com/docs/config/mappings#manually_load_mappings
  plugin = true, -- Important

  n = {
    ["<F9>"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "Toggle breakpoint.",
    },
    ["<F21>"] = { -- Shift+F9
      function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      "Toggle condition breakpoint. <S-F9>",
    },

    ["<F10>"] = {
      function()
        require("dap").step_over()
      end,
      "DAP step over.",
    },

    ["<F11>"] = {
      function()
        require("dap").step_into()
      end,
      "DAP step into.",
    },

    ["<F23>"] = { -- <S-F11>
      function()
        require("dap").step_out()
      end,
      "DAP step out. <S-F11>",
    },

    ["<F5>"] = {
      function()
        require("dap").continue()
      end,
      "DAP Continue.",
    },
    ["<F17>"] = { -- <S-F5>

      function()
        require("dap").terminate()
      end,
      "DAP terminate. <S-F5>",
    },
    ["<Leader>dp"] = {
      function()
        require("dap.ui.widgets").preview()
      end,
      "DAP Preview.",
      opts = { silent = true },
    },
    ["<Leader>dk"] = {
      function()
        require("dap.ui.widgets").hover()
      end,
      "DAP Hover",
      opts = { silent = true },
    },
    ["<Leader>ds"] = {
      function()
        require("dap").run_to_cursor()
      end,
      "Run To Cursor.",
      opts = { silent = true },
    },

    ["<Leader>du"] = {
      function()
        require("dapui").toggle()
      end,
      "Toggle Debugger UI.",
    },
    -- ["<Leader>dk"] = {
    -- 	function()
    -- 		require("dap.ui.widgets").hover()
    -- 	end,
    -- },
    -- ["<Leader>dk"] = {
    -- 	function()
    -- 		require("dap.ui.widgets").hover()
    -- 	end,
    -- },
  },
}

-- https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
M.nvim_ufo = {
  plugin = true,

  n = {
    ["zM"] = {
      function()
        require("ufo").closeAllFolds()
      end,
      "UFO close all folds.",
    },
    ["zR"] = {
      function()
        require("ufo").openAllFolds()
      end,
      "UFO open all folds.",
    },
  },
}

M.haskell_tools = {
  plugin = true,

  n = {
    ["<leader>re"] = {
      function()
        require("haskell-tools").lsp.buf_eval_all()
      end,
      "Evaluate all code snippets at once.",
    },

    ["<leader>rq"] = {
      function()
        require("haskell-tools").repl.quit()
      end,
      "Quit GHCi repl.",
    },

    ["<leader>rf"] = {
      function()
        require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0))
      end,
      "Open a GHCi repl for the current buffer.",
    },
  },
}

M.osv = {
  plugin = true,
  n = {
    ["<leader>osv"] = {
      function()
        require("osv").launch { port = 8086 }
      end,
      -- https://github.com/jbyuki/one-small-step-for-vimkind?tab=readme-ov-file#configuration
      "Start neovim lua debug server in current neovim.",
    },
  },
}

M.yanky = {
  plugin = true,
  n = {
    ["p"] = { "<Plug>(YankyPutAfter)", "Yanky put after" },
    ["P"] = { "<Plug>(YankyPutBefore)", "Yanky put before" },
    ["gp"] = { "<Plug>(YankyGPutAfter)", "Yanky grand put after" },
    ["gP"] = { "<Plug>(YankyGPutBefore)", "Yanky grand put before" },
    ["<A-k>"] = { "<Plug>(YankyPreviousEntry)", "Yanky previous entry" },
    ["<A-j>"] = { "<Plug>(YankyNextEntry)", "Yanky next entry" },
  },
  x = {
    ["p"] = { "<Plug>(YankyPutAfter)", "Yanky put after" },
    ["P"] = { "<Plug>(YankyPutBefore)", "Yanky put before" },
    ["gp"] = { "<Plug>(YankyGPutAfter)", "Yanky grand put after" },
    ["gP"] = { "<Plug>(YankyGPutBefore)", "Yanky grand put before" },
  },
}

return M
