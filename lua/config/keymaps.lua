-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

map("n", "<leader>gg", function()
	Util.float_term(
		{ require("config.directories") .. "/lazygit/bin/lazygit" },
		{ cwd = Util.get_root(), esc_esc = false }
	)
end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function()
	Util.float_term({ require("config.directories") .. "/lazygit/bin/lazygit" }, { esc_esc = false })
end, { desc = "Lazygit (cwd)" })

local function which_key_iron_repl()
	map("n", "<leader>r", "<CMD>IronRepl<CR>", { desc = "REPL", buffer = 0 })
	map("v", "<CR>", require("iron").core.visual_send, { desc = "Send to REPL", buffer = 0 })
	map("n", "<CR>", require("iron").core.send_line, { desc = "Send line to REPL", buffer = 0 })
end
vim.api.nvim_create_autocmd({ "FileType" }, { pattern = { "python", "nix" }, callback = which_key_iron_repl })

local function which_key_neotest()
	local wk = require("which-key")
	wk.register({ ["<leader>ct"] = { desc = "+testing" } })
	local function nearest()
		require("neotest").run.run()
	end
	local function runfile()
		require("neotest").run.run(vim.fn.expand("%"))
	end
	local function output()
		require("neotest").ouput.open({})
	end
	local function summary()
		require("neotest").summary.toggle()
	end

	map("n", "<leader>ctn", nearest, { desc = "Nearest test", buffer = 0 })
	map("n", "<leader>ctf", runfile, { desc = "Test file", buffer = 0 })
	map("n", "<leader>cto", output, { desc = "Test output", buffer = 0 })
	map("n", "<leader>cts", summary, { desc = "Test summary", buffer = 0 })
end
vim.api.nvim_create_autocmd({ "FileType" }, { pattern = { "python" }, callback = which_key_neotest })
