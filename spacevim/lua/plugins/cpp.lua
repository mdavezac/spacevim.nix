return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				cmake = { cmd = { require("config.directories") .. "/cpp/bin/cmake-language-server" } },
				clangd = {
					cmd = { require("config.directories") .. "/cpp/bin/clangd" },
				},
			},
		},
	},
}
