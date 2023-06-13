return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"folke/neodev.nvim",
		opts = {
			library = { plugins = { "neotest" }, types = true },
		},
	},
}
