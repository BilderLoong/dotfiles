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
    if cmd == "" and vim.fn.executable "/opt/homebrew/bin/ast-grep" == 1 then cmd = "/opt/homebrew/bin/ast-grep" end
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

    return require("snacks.picker.source.proc").proc(
      ctx:opts {
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
          if type(finish) == "table" and type(finish.line) == "number" and type(finish.column) == "number" then
            item.end_pos = { finish.line + 1, finish.column }
          end

          item.lang = entry.language
          item.text = table.concat({ item.file, tostring(item.pos[1]), tostring(item.pos[2]), item.line }, ":")
        end,
      },
      ctx
    )
  end,
}

local function find_files()
  require("snacks").picker.files {
    hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat ".git" or {}, "type") == "directory",
  }
end

local function restore_last_session()
  local auto_session = require "auto-session"
  local session_name = require("auto-session.lib").get_latest_session(auto_session.get_root_dir())

  if not session_name then
    vim.notify("No saved sessions found", vim.log.levels.WARN)
    return
  end

  auto_session.autosave_and_restore(session_name)
end

---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.picker = opts.picker or {}
    opts.picker.sources = opts.picker.sources or {}
    opts.picker.sources.ast_grep = ast_grep_source

    local git_log_source = opts.picker.sources.git_log or {}
    local upstream_git_log_config = git_log_source.config

    git_log_source.config = function(picker_opts)
      if upstream_git_log_config then picker_opts = upstream_git_log_config(picker_opts) or picker_opts end
      if not picker_opts.current_file then return picker_opts end

      picker_opts.previewers.diff.style = "terminal"
      picker_opts.layout = {
        preset = "default",
        fullscreen = true,
        config = function(layout) layout.layout[2].width = 0.8 end,
      }
      return picker_opts
    end
    opts.picker.sources.git_log = git_log_source

    local dashboard_keys = vim.tbl_get(opts, "dashboard", "preset", "keys") or {}
    for _, key in ipairs(dashboard_keys) do
      if key.key == "f" then key.action = find_files end
      if key.key == "s" then key.action = restore_last_session end
    end
  end,
}
