local function list_plugins(directory, plugins)
	local pinned = {}
	for _, plugin in pairs(plugins) do
		local path = directory:gsub("/+$", "") .. "/" .. plugin.name
		local stat_path = vim.loop.fs_lstat(path)
		if stat_path ~= nil then
			pinned[#pinned + 1] = { plugin[1], name = plugin.name, dir = path }
		else
			print("Missing static plugin " .. vim.inspect(plugin))
		end
	end
	return pinned
end
local plugins = {
	{ "L3MON4D3/LuaSnip", name = "LuaSnip" },
	{ "akinsho/toggleterm.nvim", name = "toggleterm.nvim" },
	{ "Vigemus/iron.nvim", name = "iron.nvim" },
	{ "LazyVim/LazyVim", name = "LazyVim" },
	{ "nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
	{ "willothy/flatten.nvim", name = "flatten.nvim" },
	{ "nvim-telescope/telescope.nvim", name = "telescope.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", name = "telescope-fzf-native.nvim" },
	{ "akinsho/bufferline.nvim", name = "bufferline.nvim" },
	{ "hrsh7th/nvim-cmp", name = "nvim-cmp" },
	{ "hrsh7th/cmp-buffer", name = "cmp-buffer" },
	{ "hrsh7th/cmp-nvim-lsp", name = "cmp-nvim-lsp" },
	{ "hrsh7th/cmp-path", name = "cmp-path" },
	{ "saadparwaiz1/cmp_luasnip", name = "cmp_luasnip" },
	{ "MunifTanjim/nui.nvim", name = "nui.nvim" },
	{ "folke/noice.nvim", name = "noice.nvim" },
	{ "nvim-lualine/lualine.nvim", name = "lualine.nvim" },
	{ "folke/which-key.nvim", name = "which-key.nvim" },
	{ "stevearc/dressing.nvim", name = "dressing.nvim" },
	{ "stevearc/conform.nvim", name = "conform.nvim" },
	{ "folke/trouble.nvim", name = "trouble.nvim" },
	{ "mrcjkb/rustaceanvim", name = "rustaceanvim" },
	{ "mrcjkb/haskell-tools.nvim", name = "haskell-tools" },
	{ "nvim-neotest/neotest", name = "neotest" },
	{ "nvim-neotest/neotest-python", name = "neotest-python" },
	{ "alfaix/neotest-gtest", name = "neotest-gtest" },
	{ "mrcjkb/neotest-haskell", name = "neotest-haskell" },
	{ "marilari88/neotest-vitest", name = "neotest-vitest" },
	{ "echasnovski/mini.base16", name = "mini.base16" },
}
return list_plugins(require("config.directories"), plugins)
