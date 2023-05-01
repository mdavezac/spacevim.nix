return {
	{
		"nvim-treesitter/nvim-treesitter",
		name = "nvim-treesitter",
		dir = require("config.directories") .. "/treesitter",
		lazy = false,
		pin = true,
		opts = { ensure_installed = {} },
	},
	{ "L3MON4D3/LuaSnip", name = "LuaSnip", dir = require("config.directories") .. "/luasnip", pin = true },
}
