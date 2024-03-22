vim.b.minicomment_config = {
	options = {
		custom_commentstring = function()
			return "// %s"
		end,
	},
}
