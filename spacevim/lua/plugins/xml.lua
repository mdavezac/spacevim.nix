return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				lemminx = { cmd = { require("config.directories") .. "/xml/bin/lemminx" } },
			},
		},
	},
}
