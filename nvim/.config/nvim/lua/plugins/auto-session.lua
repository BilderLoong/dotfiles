return {
  "rmagatti/auto-session",
  event = "VeryLazy",
  cmd = {
    "Autosession",
    "SessionDelete",
    "SessionRestore",
    "SessionRestoreFromFile",
    "SessionSave",
  },
  opts = {
    auto_restore_enabled = false,
    log_level = vim.log.levels.ERROR,
    session_lens = {
      load_on_setup = true,
      theme_conf = { border = true },
      previewer = true,
    },
    pre_save_cmds = {
      "lua if vim.fn.exists(':NvimTreeClose') > 0 then vim.cmd('tabdo NvimTreeClose') end",
      "lua if vim.fn.exists(':DiffviewClose') > 0 then vim.cmd('tabdo DiffviewClose') end",
    },
  },
  config = function(_, opts)
    require("auto-session").setup(opts)
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
}