return {
	{
		"simrat39/rust-tools.nvim",
		name = "rust-tools",
		ft = { "rust" },
		opts = {
			server = {
				cmd = { require("config.directories") .. "/rust/bin/rust-analyzer" },
			},
		},
	},
}
