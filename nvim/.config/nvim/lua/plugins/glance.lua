return
--- @type LazySpec
{
  "dnlhc/glance.nvim",
  cmd = { "Glance" },
  -- https://github.com/gbprod/nord.nvim#-integrations
  -- opts = require("nord.plugins.glance").make_opts {
  --   hooks = {
  --     before_open = function(results, open, jump)
  --       if #results == 1 then
  --         jump(results[1])
  --       else
  --         open(results)
  --       end
  --     end,
  --   },
  --   border = { enable = true },
  --   use_trouble_qf = true,
  --   folds = {
  --     folded = false,
  --   },
  -- },

  -- config = function() require("glance").setup {} end,
}
