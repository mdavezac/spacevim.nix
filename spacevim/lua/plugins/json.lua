return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				jsonls = {
					cmd = { require("config.directories") .. "/json/bin/vscode-json-language-server", "--stdio" },
				},
			},
		},
	},
}
