require("catppuccin").setup(
    {
		transparency = false,
		term_colors = false,
		styles = {
			comments = "italic",
			functions = "NONE",
			keywords = "bold",
			strings = "italic",
			variables = "NONE",
		},
		integrations = {
			treesitter = false,
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
            nvimtree = {
                enabled = true,
                show_root = false,
                transparent_panel = false,
            },
            cmp = true,
            lsp_trouble = true,
		}
	}
)
