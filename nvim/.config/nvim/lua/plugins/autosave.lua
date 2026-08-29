return {
	"okuuva/auto-save.nvim",
	version = "^1.0.0",
	cmd = "ASToggle",
	event = { "User AstroFile", "InsertEnter" },
	opts = {
		noautocmd = true,
	},
}
