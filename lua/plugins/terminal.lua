return {
	{
		"akinsho/toggleterm.nvim",
		dir = require("config.directories") .. "/toggleterm",
		opts = {
			size = 100,
			direction = "vertical",
			insert_mappings = false,
			terminal_mapping = false,
		},
		keys = {
            {
			"<leader>;",
			"<Cmd>exe v:count1 . 'ToggleTerm'<CR>",
			desc = "Terminal",}
		},
	},
	{
		"aserowy/tmux.nvim",
		opts = {
			copy_sync = { enable = false },
		},
		keys = {
			"<C-h>",
			"<C-l>",
			"<C-j>",
			"<C-k>",
			"<A-h>",
			"<A-l>",
			"<A-j>",
			"<A-k>",
		},
	},
	{
		"declancm/maximize.nvim",
		opts = { default_keymaps = false },
		keys = {
			{
				"<leader>z",
				function()
					require("maximize").toggle()
				end,
				desc = "Maximize current window",
			},
		},
	},
}
