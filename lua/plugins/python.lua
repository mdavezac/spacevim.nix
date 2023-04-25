return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(opts.sources, nls.builtins.formatting.isort)
			table.insert(opts.sources, nls.builtins.formatting.black)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = { servers = { pyright = { cmd = require("config.directories").pyright } } },
	},
}
