return {
  "dnlhc/glance.nvim",
  cmd = { "Glance" },
  config = function()
    require("glance").setup {
      hooks = {
        before_open = function(results, open, jump)
          if #results == 1 then
            jump(results[1])
          else
            open(results)
          end
        end,
      },
      border = { enable = true },
      use_trouble_qf = true,
    }
  end,
}
