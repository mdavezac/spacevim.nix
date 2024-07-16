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
					require("config.directories") .. "/rg/bin/rg",
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
		"hedyhli/outline.nvim",
		keys = { { "<leader>cO", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
	},
}
