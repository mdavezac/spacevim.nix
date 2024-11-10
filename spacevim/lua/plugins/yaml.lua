return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { yaml = { "yamlfmt" } },
			formatters = { yamlfmt = { command = require("config.directories") .. "/yaml/bin/yamlfmt" } },
		},
	},
}
