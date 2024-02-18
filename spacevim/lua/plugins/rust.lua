return {
	{
		"nvim-neotest/neotest",
		ft = { "rust" },
		opts = { adapters = { ["rustaceanvim.neotest"] = {} } },
	},
	{
		"mrcjkb/rustaceanvim",
		name = "rustaceanvim",
		ft = { "rust" },
	},
}
