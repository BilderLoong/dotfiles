return {
  "dmtrKovalenko/fff",
  lazy = false, -- Load at startup; FFF controls when indexing starts
  build = function() require("fff.download").download_or_build_binary() end,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("fff_resume_tracking", { clear = true }),
      pattern = "fff_input",
      callback = function() require("picker_resume").mark "fff" end,
    })
  end,
  opts = {
    prompt_vim_mode = true,
    keymaps = {
      move_down = { "<Down>", "<C-n>", "<C-j>" },
      move_up = { "<Up>", "<C-p>", "<C-k>" },
      preview_scroll_up = "<C-b>",
      preview_scroll_down = "<C-f>",
    },
    lazy_sync = true, -- Initialize the search engine when first needed
    enable_home_dir_scanning = false,
    debug = {
      enabled = false,
      show_scores = false,
    },
  },
}
