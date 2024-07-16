return {
	{
		"stevearc/conform.nvim",
		opts = { formatters = { stylua = { command = require("config.directories") .. "/stylua/bin/stylua" } } },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				lua_ls = {
					cmd = { require("config.directories") .. "/luals/bin/lua-language-server" },
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
						},
					},
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			show_line = true,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		opts = function(_, opts)
			require("nvim-treesitter.install").compilers = { require("config.directories") .. "/treesitter/bin/zig" }
			return vim.tbl_deep_extend("force", opts or {}, {
				ensure_installed = {},
				parser_install_dir = vim.fn.expand("~/.local/state/nvim/tree-sitter"),
			})
		end,
	},
}
