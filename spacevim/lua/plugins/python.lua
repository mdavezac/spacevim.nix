return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { python = { "black", "isort" } },
			formatters = {
				black = { command = require("config.directories") .. "/pytools/bin/black" },
				isort = {
					command = require("config.directories") .. "/pytools/bin/isort",
					args = { "--profile", "black", "--stdout", "--filename", "$FILENAME", "-" },
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyright = {
					cmd = { require("config.directories") .. "/pytools/bin/pyright-langserver", "--stdio" },
				},
			},
		},
	},
	{
		"Vigemus/iron.nvim",
		ft = { "python" },
		opts = {
			config = {
				repl_definition = {
					python = { command = { "python" } },
				},
			},
		},
	},
	{
		"nvim-neotest/neotest",
		ft = { "python" },
		opts = {
			adapters = {
				["neotest-python"] = {
					runner = "pytest",
					-- python = ".venv/bin/python",
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { indent = { disable = { "python" } } },
	},
	{ "nvim-neotest/neotest-python" },
}
