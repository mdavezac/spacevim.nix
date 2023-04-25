local nullopts = function(_, opts)
	for i, source in ipairs(opts.sources) do
		if source.name == "stylua" then
			opts.sources[i] = source.with({ command = require("config.directories").stylua })
		end
	end
	return opts
end

return {
	{ "jose-elias-alvarez/null-ls.nvim", opts = nullopts },
	{ "neovim/nvim-lspconfig", opts = { servers = { lua_ls = { cmd = { require("config.directories").lua_ls } } } } },
}
