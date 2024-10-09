return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				eslint = {
					cmd = {
						require("config.directories") .. "/typescript/bin/vscode-eslint-language-server",
						"--stdio",
					},
				},
				vtsls = {
					cmd = { require("config.directories") .. "/typescript/bin/vtsls", "--stdio" },
				},
			},
			setup = {
				eslint = function()
					require("lazyvim.util").lsp.on_attach(function(client)
						if client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = false
						elseif client.name == "vtsls" then
							client.server_capabilities.documentFormattingProvider = false
						end
					end)
				end,
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { typescript = { "prettierd" }, javascript = { "prettierd" } },
			formatters = {
				prettierd = {
					command = require("config.directories") .. "/typescript/bin/prettierd",
					stop_after_first = true,
				},
			},
		},
	},
}
