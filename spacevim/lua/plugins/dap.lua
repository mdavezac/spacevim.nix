return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>d!",
        -- stylua: ignore
				function() require("dap").clear_breakpoints() end,
				desc = "Clear breakpoints",
			},
		},
	},
}
