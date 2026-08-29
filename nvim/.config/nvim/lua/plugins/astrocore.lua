local function find_files()
  require("snacks").picker.files {
    hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat ".git" or {}, "type") == "directory",
  }
end

local function navigate_buffer(direction)
  require("astrocore.buffer").nav(direction * vim.v.count1)
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  init = function()
    -- Neovim defines these globally before Lazy merges plugin options. Remove
    -- superseded aliases early so shorter replacement mappings are immediate.
    for _, lhs in ipairs { "grr", "gri", "gra", "grn", "]b", "[b" } do
      pcall(vim.keymap.del, "n", lhs)
    end
    pcall(vim.keymap.del, "x", "gra")
  end,
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local maps = require("astrocore").empty_map_table()

    maps.n.zt = { "zt3<C-Y>", desc = "Scroll line to top with context" }
    maps.x.zt = { "zt3<C-Y>", desc = "Scroll line to top with context" }

    maps.n["<C-P>"] = { find_files, desc = "Find files" }
    maps.i["<C-P>"] = { find_files, desc = "Find files" }
    maps.x["<C-P>"] = { find_files, desc = "Find files" }

    maps.n["<C-N>"] = { "<Cmd>Neotree toggle<CR>", desc = "Toggle Explorer" }
    maps.i["<C-N>"] = { "<Cmd>Neotree toggle<CR>", desc = "Toggle Explorer" }

    maps.n["<Leader>fA"] = { function() require("snacks").picker.ast_grep() end, desc = "Find AST patterns" }
    maps.n["<Leader>fM"] = { function() require("snacks").picker.man() end, desc = "Find man" }

    maps.n["<Tab>"] = { function() navigate_buffer(1) end, desc = "Next buffer" }
    maps.n["<S-Tab>"] = { function() navigate_buffer(-1) end, desc = "Previous buffer" }

    for _, lhs in ipairs {
      "<Leader>w",
      "<C-S>",
      "<Leader>q",
      "<Leader>Q",
      "<C-Q>",
      "<Leader>n",
      "<Leader>ff",
      "<Leader>fm",
      "<Leader>e",
      "<Leader>o",
      "<Leader>/",
      "]b",
      "[b",
      "\\",
      "<Leader>pi",
      "<Leader>ps",
      "<Leader>pS",
      "<Leader>pu",
      "<Leader>pU",
      "<Leader>pm",
      "<Leader>pM",
      "<Leader>pa",
    } do
      maps.n[lhs] = false
    end

    maps.x["<Leader>/"] = false

    opts.mappings = require("astrocore").extend_tbl(opts.mappings, maps)
  end,
}