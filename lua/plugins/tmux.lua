return {
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
