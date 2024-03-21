return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { nix = { "alejandra" } },
			formatters = { alejandra = { command = require("config.directories") .. "/alejandra/bin/alejandra" } },
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				nil_ls = {
					cmd = { require("config.directories") .. "/nil/bin/nil" },
				},
			},
		},
	},
	{
		"Vigemus/iron.nvim",
		ft = { "nix" },
		opts = {
			config = {
				repl_definition = {
					nix = { command = { "nix", "repl" } },
				},
			},
		},
	},
}
