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
		config = function()
			local Config = require("lazyvim.config")
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(Config.icons.dap) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			-- setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local filetypes = {
				["node"] = { "javascriptreact", "typescriptreact", "typescript", "javascript" },
				["pwa-node"] = { "javascriptreact", "typescriptreact", "typescript", "javascript" },
			}
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
			vscode.load_launchjs(nil, filetypes)
		end,
	},
}
