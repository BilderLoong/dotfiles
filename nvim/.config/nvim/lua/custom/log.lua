local log = require("structlog")
local M = {}

log.configure({
	my_logger = {
		pipelines = {
			{
				log.level.INFO,
				{
					log.processors.Timestamper("%H:%M:%S"),
				},
				log.formatters.Format( --
					"%s [%s] %s: %-30s",
					{ "timestamp", "level", "logger_name", "msg" }
				),
				log.sinks.Console(),
			},
		},
	},
	other_logger = {
		pipelines = { ... },
	},
})

M.logger = log.get_logger("my_logger")

return M
