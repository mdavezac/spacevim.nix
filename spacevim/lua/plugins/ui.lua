return {
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
}
