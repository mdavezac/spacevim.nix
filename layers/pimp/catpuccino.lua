local catppuccino = require("catppuccino")

catppuccino.setup(
    {
		colorscheme = "dark_catppuccino",
		transparency = false,
		term_colors = false,
		styles = {
			comments = "italic",
			functions = "NONE",
			keywords = "italic",
			strings = "NONE",
			variables = "NONE",
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = "italic",
					hints = "italic",
					warnings = "italic",
					information = "italic",
				},
				underlines = {
					errors = "underline",
					hints = "underline",
					warnings = "underline",
					information = "underline",
				}
			},
			gitsigns = true,
			telescope = true,
			which_key = true,
			neogit = true,
			barbar = true,
			hop = true,
		}
	}
)
