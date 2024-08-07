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
		"MeanderingProgrammer/markdown.nvim",
		opts = {
			file_types = { "markdown", "norg", "rmd", "org" },
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = {},
			},
		},
		ft = { "markdown", "norg", "rmd", "org" },
		config = function(_, opts)
			require("render-markdown").setup(opts)
			LazyVim.toggle.map("<leader>um", {
				name = "Render Markdown",
				get = function()
					return require("render-markdown.state").enabled
				end,
				set = function(enabled)
					local m = require("render-markdown")
					if enabled then
						m.enable()
					else
						m.disable()
					end
				end,
			})
		end,
	},
}
