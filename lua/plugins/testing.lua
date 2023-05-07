local localdir = require("config.directories")
return {
	{
		"nvim-neotest/neotest",
		dir = localdir .. "/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},
	},
	{
		"folke/neodev.nvim",
		opts = {
			library = { plugins = { "neotest" }, types = true },
		},
	},
	{ "nvim-neotest/neotest-python", dir = localdir .. "/neotest-python", name = "neotest-python" },
}
