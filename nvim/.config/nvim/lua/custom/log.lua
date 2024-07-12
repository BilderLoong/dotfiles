local log = require "structlog"

--- Usage
--- require ('custom.log'):trace('This log will be log into a file.')

local stack_level = 1

log.configure {
  debug_logger = {
    pipelines = {
      {
        level = log.level.INFO,
        processors = {
          log.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = stack_level }),
          log.processors.Timestamper "%H:%M:%S",
        },
        formatter = log.formatters.FormatColorizer( --
          "%s [%s] %s: %-30s",
          { "timestamp", "level", "logger_name", "msg" },
          { level = log.formatters.FormatColorizer.color_level() }
        ),
        sink = log.sinks.Console(),
      },
      {
        level = log.level.WARN,
        processors = {},
        formatter = log.formatters.Format( --
          "%s",
          { "msg" },
          { blacklist = { "level", "logger_name" } }
        ),
        sink = log.sinks.NvimNotify(),
      },
      {
        level = log.level.TRACE,
        processors = {
          -- https://tastyep.github.io/structlog.nvim/modules/structlog.processors.stack_writer.html#Functions
          -- The stack_level should be 1, instead of 0. Otherwise it will always show the location of this file
          -- instead of the place that use the log.
          log.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = stack_level }),
          log.processors.Timestamper "%H:%M:%S",
        },
        formatter = log.formatters.Format( --
          "%s [%s] %s: %-30s",
          { "timestamp", "level", "logger_name", "msg" }
        ),
        sink = log.sinks.File(vim.fn.stdpath "log" .. "/debug.log"),
      },
    },
  },
}


return log.get_logger "debug_logger"
