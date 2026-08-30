---@type LazySpec
return {
  "mrcjkb/rustaceanvim",
  optional = true,
  opts = function(_, opts)
    opts.server = opts.server or {}
    local original_settings = opts.server.settings

    opts.server.settings = function(project_root, default_settings)
      local settings
      if type(original_settings) == "function" then
        settings = original_settings(project_root, default_settings)
      elseif type(original_settings) == "table" then
        settings = vim.deepcopy(original_settings)
      else
        settings = vim.deepcopy(default_settings or {})
      end

      if type(settings) ~= "table" then settings = {} end
      settings["rust-analyzer"] = settings["rust-analyzer"] or {}
      settings["rust-analyzer"].files = settings["rust-analyzer"].files or {}
      settings["rust-analyzer"].files.watcher = "client" -- "server" config 

      return settings
    end
  end,
}
