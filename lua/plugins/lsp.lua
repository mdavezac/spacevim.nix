local nullopts = function(_, opts)
	for i, source in ipairs(opts.sources) do
		if source.name == "stylua" then
			opts.sources[i] = source.with({ command = require("config.directories") .. "/stylua/bin/stylua" })
		end
	end
	return opts
end

return {
	{ "jose-elias-alvarez/null-ls.nvim", opts = nullopts },
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
	{ "nvim-treesitter/nvim-treesitter", lazy = false, opts = { ensure_installed = {} } },
}
