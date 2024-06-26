local M = {}

function M.setup()
  local dap = require "dap"

  -- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L171
  dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
  end

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
    },
  }
end

return M
