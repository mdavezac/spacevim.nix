return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				taplo = {
					cmd = { require("config.directories") .. "/taplo-lsp/bin/taplo", "lsp", "stdio" },
				},
			},
		},
	},
}
