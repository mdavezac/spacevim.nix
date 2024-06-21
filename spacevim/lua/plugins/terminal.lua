return {
	{
		"Vigemus/iron.nvim",
		main = "iron.core",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts or {}, {
				config = {
					repl_open_cmd = require("iron.view").split.vertical.botright(
						"50%",
						{ number = false, relativenumber = false }
					),
				},
				keymaps = {},
			})
		end,
		filtype = {},
	},
	{
		"akinsho/toggleterm.nvim",
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
				desc = "Terminal",
			},
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
		opts = {},
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
