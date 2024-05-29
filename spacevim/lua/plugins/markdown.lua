return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { markdown = { "deno_fmt" } },
			formatters = {
				deno_fmt = { command = require("config.directories") .. "/markdown/bin/deno" },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				marksman = {
					cmd = { require("config.directories") .. "/markdown/bin/marksman", "server" },
				},
			},
		},
	},
	{
		"lukas-reineke/headlines.nvim",
		opts = function()
			local opts = {}
			for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
				opts[ft] = {
					headline_highlights = {},
					-- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
					bullets = {},
					fat_headline_lower_string = "▀",
				}
				for i = 1, 6 do
					local hl = "Headline" .. i
					vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
					table.insert(opts[ft].headline_highlights, hl)
				end
			end
			return opts
		end,
		ft = { "markdown", "norg", "rmd", "org" },
		config = function(_, opts)
			-- PERF: schedule to prevent headlines slowing down opening a file
			vim.schedule(function()
				require("headlines").setup(opts)
				require("headlines").refresh()
			end)
		end,
	},
}
