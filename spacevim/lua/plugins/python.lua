return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { python = { "black", "isort" } },
			formatters = {
				black = { command = require("config.directories") .. "/pytools/bin/black" },
				isort = {
					command = require("config.directories") .. "/pytools/bin/isort",
					args = { "--profile", "black", "--stdout", "--filename", "$FILENAME", "-" },
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyright = {
					cmd = { require("config.directories") .. "/pytools/bin/basedpyright-langserver", "--stdio" },
				},
				ruff_lsp = {
					cmd = { require("config.directories") .. "/pytools/bin/ruff-lsp" },
					keys = {
						{
							"<leader>co",
							function()
								vim.lsp.buf.code_action({
									apply = true,
									context = {
										only = { "source.organizeImports" },
										diagnostics = {},
									},
								})
							end,
							desc = "Organize Imports",
						},
					},
				},
			},
			setup = {
				ruff_lsp = function()
					require("lazyvim.util").lsp.on_attach(function(client, _)
						if client.name == "ruff_lsp" then
							-- Disable hover in favor of Pyright
							client.server_capabilities.hoverProvider = false
						end
					end)
				end,
			},
		},
	},
	{
		"Vigemus/iron.nvim",
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
		ft = { "python" },
		opts = {
			adapters = {
				["neotest-python"] = {
					runner = "pytest",
					-- python = ".venv/bin/python",
				},
			},
		},
		dependencies = { "nvim-neotest/neotest-python" },
	},
	{ "nvim-neotest/neotest-python", ft = { "python" } },
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { indent = { disable = { "python" } } },
	},
}
