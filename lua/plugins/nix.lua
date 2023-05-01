return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(
				opts.sources,
				nls.builtins.formatting.alejandra.with({
					command = require("config.directories") .. "/alejandra/bin/alejandra",
				})
			)
		end,
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
		dir = require("config.directories") .. "/iron",
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
