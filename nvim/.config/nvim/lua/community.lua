-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  -- TODO: Config to use with vscode.
  -- { import = "astrocommunity.recipes.vscode" }, -- [VS Code Integration | AstroNvim Documentation](https://docs.astronvim.com/recipes/vscode/)
}
