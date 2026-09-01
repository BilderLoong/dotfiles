-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    opts = {
    },
    config = function(_, opts) require("nord").setup(opts) end,
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- change colorscheme
      colorscheme = "nord",
      -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
      highlights = {
        init = { -- this table overrides highlights in all themes
          -- Normal = { bg = "#000000" },
        },
        nord = { -- a table of overrides/changes when applying the Nord theme
          Comment = { fg = "#75809C", italic = true },
          ["@comment"] = { fg = "#75809C", italic = true },
          -- NvChad-era diff colors, ported from the pre-AstroNvim config
          -- (nvim/.config/nvim/lua/custom/chadrc.lua @ f7ce9e03): hl_override used
          -- bg = { "green", -25 } etc., which base46 resolves through
          -- change_hex_lightness against the Nord palette.
          DiffAdd = { bg = "#628149", fg = "NONE" },
          DiffDelete = { bg = "#BC5963", fg = "NONE" },
          DiffChange = { bg = "#906819", fg = "NONE" },
          DiffText = { bg = "#BC8820", fg = "NONE" },
        },
      },
      -- Icons can be configured throughout the interface
      icons = {
        -- configure the loading of the lsp in the status line
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
      },
    },
  },
}
