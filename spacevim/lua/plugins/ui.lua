return {
	{ "lukas-reineke/indent-blankline.nvim", enabled = false },
	{ "folke/which-key.nvim", opts = { preset = "helix" } },
	{
		"akinsho/bufferline.nvim",
		keys = { { "gb", "<CMD>BufferLinePick<CR>", { desc = "Pick buffer" } } },
	},
	{
		"telescope.nvim",
		opts = {
			defaults = {
				vimgrep_arguments = {
					require("config.directories") .. "/search/bin/rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
			},
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		opts = {
			headerMaxWidth = 80,
			engines = {
				ripgrep = { path = require("config.directories") .. "/search/bin/rg" },
				astgrep = { path = require("config.directories") .. "/search/bin/ast-grep" },
			},
		},
	},
	{
		"hedyhli/outline.nvim",
		keys = { { "<leader>cO", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
	},
}
