return {
  "dmtrKovalenko/fff",
  lazy = false, -- Load at startup; FFF controls when indexing starts
  build = function() require("fff.download").download_or_build_binary() end,
  opts = {
    lazy_sync = true, -- Initialize the search engine when first needed
    enable_home_dir_scanning = false,
    debug = {
      enabled = false,
      show_scores = false,
    },
  },
}
