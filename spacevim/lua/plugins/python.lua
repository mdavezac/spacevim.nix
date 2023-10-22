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
		opts = function(_, opts)
			if opts.adapters ~= nil then
				table.insert(opts.adapters, require("neotest-python"))
			else
				opts.adapters = { require("neotest-python") }
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { indent = { disable = { "python" } } },
	},
	{ "nvim-neotest/neotest-python" },
	{ "stevearc/conform.nvim", opts = { format_on_save = { timeout_ms = 1000 } } },
}
