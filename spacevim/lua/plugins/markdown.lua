return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { markdown = { "deno_fmt" } },
			formatters = {
				deno_fmt = { command = require("config.directories") .. "/deno/bin/deno" },
			},
		},
	},
}
