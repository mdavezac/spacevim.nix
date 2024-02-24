return {
	{
		"nvim-pack/nvim-spectre",
		build = false,
		cmd = "Spectre",
		opts = {
			find_engine = {
				["rg"] = { cmd = require("config.directories") .. "/rg/bin/rg" },
			},
			replace_engine = {
				["sed"] = { cmd = require("config.directories") .. "/sed/bin/sed" },
			},
		},
	},
}
