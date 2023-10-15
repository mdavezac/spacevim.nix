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
				rnix = {
					cmd = { require("config.directories") .. "/rnix/bin/rnix-lsp" },
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
