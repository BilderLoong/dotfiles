local M = {}
local original, applied

-- Move comments slightly toward Normal text; retain the theme's other styles.
function M.setup()
  local function apply()
    local current = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    if not current.fg or not normal.fg then return end
    -- Repeated setup/events must not blend an already adjusted color again.
    if not applied or not vim.deep_equal(current, applied) then original = current end
    local highlight = vim.tbl_extend("force", original, {
      fg = require("unused_highlight").blend(original.fg, normal.fg, 0.875),
    })
    vim.api.nvim_set_hl(0, "Comment", highlight)
    applied = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
    -- Nord defines Treesitter comments separately from classic syntax comments.
    local treesitter = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
    if treesitter.fg == original.fg then
      vim.api.nvim_set_hl(0, "@comment", vim.tbl_extend("force", treesitter, { fg = highlight.fg }))
    end
  end
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("comment_highlight", { clear = true }),
    desc = "Make theme comments slightly easier to read",
    callback = apply,
  })
  apply()
end

return M
