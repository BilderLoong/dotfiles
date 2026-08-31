local function apply_winhl(winid, overrides)
  local groups = {}

  for item in vim.gsplit(vim.wo[winid].winhl, ",", { plain = true, trimempty = true }) do
    local source, target = item:match "^([^:]+):(.+)$"
    if source then groups[source] = target end
  end

  for source, target in pairs(overrides) do
    groups[source] = target
  end

  local items = {}
  for source, target in pairs(groups) do
    items[#items + 1] = source .. ":" .. target
  end
  table.sort(items)
  vim.wo[winid].winhl = table.concat(items, ",")
end

local function use_vscode_diff_colors(_, winid, ctx)
  if not ctx.layout_name:match "^diff2_" then return end

  local side = ctx.symbol == "a" and "Old" or ctx.symbol == "b" and "New" or nil
  if not side then return end

  apply_winhl(winid, {
    DiffAdd = "DiffviewDiff" .. side .. "Line",
    DiffChange = "DiffviewDiff" .. side .. "Line",
    DiffDelete = "DiffviewDiffDeleteDim",
    DiffText = "DiffviewDiff" .. side .. "Text",
  })
end

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  opts = {
    enhanced_diff_hl = true,
    hooks = {
      diff_buf_win_enter = use_vscode_diff_colors,
    },
  },
}
