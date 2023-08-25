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
}

local telescope_i_n = {
  ["<A-d>"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find document symbols" },
  ["<A-b>"] = { "<cmd> Telescope <CR>", "Telescope builtins" },
  ["<A-k>"] = { "<cmd> Telescope keymaps <CR>", "Telescope keymaps" },
  ["<A-p>"] = { "<cmd> Telescope commands <CR>", "Telescope commands" },
  ["<A-r>"] = { "<cmd> Telescope resume <CR>", "Resume last Telescope picker" },
  ["<F1>"] = {
    function()
      require("fzf-lua").help_tags()
    end,
    "Fzf lua help tags.",
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
    ["<leader>f"] = {
      function()
        require("fzf-lua").files {
          follow = true,
        }
      end,
      "Fzf-lua find files.",
    },
  }),
  i = vim.tbl_deep_extend("force", telescope_i_n, {}),
}

M.lspconfig = {
  n = {
    ["gd"] = {
      "<cmd> Telescope lsp_definitions  <CR>",
      "Telescope LSP definitions",
    },
    ["gr"] = {
      "<cmd> Telescope lsp_references <CR>",
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
    ["gA"] = {
      "<cmd> Lspsaga finder <CR>",
      "Show LSP methods search result.",
    },
    -- https://nvimdev.github.io/lspsaga/codeaction/
    ["<leader>ca"] = {
      "<cmd> Lspsaga code_action <CR>",
      "LSPsaga code action.",
    },
    -- https://nvimdev.github.io/lspsaga/diagnostic/
    ["<leader>d"] = {
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

    ["<F10>"] = {
      function()
        require("dap").step_over()
      end,
      "DAP step over.",
    },

    ["<F5>"] = {
      function()
        require("dap").continue()
      end,
      "DAP continue.",
    },

    ["<F11>"] = {
      function()
        require("dap").step_into()
      end,
      "DAP step into",
    },

    ["<S-F11>"] = {
      function()
        require("dap").step_out()
      end,
      "DAP Continue",
    },

    ["<F5>"] = {
      function()
        require("dap").continue()
      end,
      "DAP Continue",
    },

  },
}

return M
