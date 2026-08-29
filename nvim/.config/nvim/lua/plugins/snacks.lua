local ast_grep_source = {
  title = "AST Grep",
  format = "file",
  show_empty = true,
  live = true,
  supports_live = true,
  hidden = true,
  ignored = false,
  follow = false,

  finder = function(opts, ctx)
    local pattern = ctx.filter.search
    if vim.trim(pattern) == "" then return {} end

    local cwd = opts.cwd
    if not cwd then
      local file = vim.api.nvim_buf_get_name(ctx.filter.current_buf)
      cwd = file ~= "" and Snacks.git.get_root(file) or nil
      cwd = cwd or ctx:cwd()
    end
    cwd = vim.fs.normalize(cwd or vim.fn.getcwd(0))
    ctx.picker:set_cwd(cwd)

    local cmd = vim.fn.exepath "ast-grep"
    if cmd == "" then cmd = vim.fn.exepath "sg" end
    if cmd == "" and vim.fn.executable "/opt/homebrew/bin/ast-grep" == 1 then
      cmd = "/opt/homebrew/bin/ast-grep"
    end
    if cmd == "" then
      Snacks.notify.error "ast-grep executable not found"
      return {}
    end

    local args = {
      "run",
      "--color=never",
      "--json=stream",
      "--pattern=" .. pattern,
    }

    if opts.lang and opts.lang ~= "" then vim.list_extend(args, { "--lang", opts.lang }) end
    if opts.hidden then table.insert(args, "--no-ignore=hidden") end
    if opts.ignored then
      for _, kind in ipairs { "dot", "exclude", "global", "parent", "vcs" } do
        table.insert(args, "--no-ignore=" .. kind)
      end
    end
    if opts.follow then table.insert(args, "--follow") end
    table.insert(args, ".")

    return require("snacks.picker.source.proc").proc(ctx:opts {
      cmd = cmd,
      args = args,
      cwd = cwd,
      notify = false,
      transform = function(item)
        local ok, entry = pcall(vim.json.decode, item.text)
        if
          not ok
          or type(entry) ~= "table"
          or type(entry.file) ~= "string"
          or type(entry.range) ~= "table"
          or type(entry.range.start) ~= "table"
        then
          return false
        end

        local start = entry.range.start
        if type(start.line) ~= "number" or type(start.column) ~= "number" then return false end

        local display = type(entry.lines) == "string" and entry.lines
          or type(entry.text) == "string" and entry.text
          or ""
        local first = display:match "([^\r\n]*)" or display
        local multiline = display:find "[\r\n]" ~= nil

        item.cwd = cwd
        item.file = entry.file
        item.line = vim.trim(first) .. (multiline and " …" or "")
        item.pos = { start.line + 1, start.column }

        local finish = entry.range["end"]
        if
          type(finish) == "table"
          and type(finish.line) == "number"
          and type(finish.column) == "number"
        then
          item.end_pos = { finish.line + 1, finish.column }
        end

        item.lang = entry.language
        item.text = table.concat({ item.file, tostring(item.pos[1]), tostring(item.pos[2]), item.line }, ":")
      end,
    }, ctx)
  end,
}

return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.picker = opts.picker or {}
    opts.picker.sources = opts.picker.sources or {}
    opts.picker.sources.ast_grep = ast_grep_source

    local dashboard_keys = vim.tbl_get(opts, "dashboard", "preset", "keys") or {}
    for _, key in ipairs(dashboard_keys) do
      if key.key == "f" then key.action = "<C-P>" end
      if key.key == "s" then key.action = "<C-P>" end
    end
  end,
}
