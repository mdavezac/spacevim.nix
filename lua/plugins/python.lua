local localdir = require("config.directories")
return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(
				opts.sources,
				nls.builtins.formatting.black.with({
					command = require("config.directories") .. "/pytools/bin/black",
				})
			)
			table.insert(
				opts.sources,
				nls.builtins.formatting.isort.with({
					command = require("config.directories") .. "/pytools/bin/isort",
					args = { "--profile", "black", "--stdout", "--filename", "$FILENAME", "-" },
				})
			)
		end,
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
		dir = localdir .. "/iron",
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
		dir = localdir .. "/neotest",
		ft = { "python" },
		opts = function(_, opts)
			if opts.adapters ~= nil then
				table.insert(opts.adapters, require("neotest-python"))
			else
				opts.adapters = { require("neotest-python") }
			end
		end,
	},
}
