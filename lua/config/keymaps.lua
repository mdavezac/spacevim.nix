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
	map("n", "<leader>r", "<CMD>IronRepl<CR>", { desc = "REPL" })
	map("v", "<CR>", require("iron").core.visual_send, { desc = "Send to REPL" })
	map("n", "<CR>", require("iron").core.send_line, { desc = "Send line to REPL" })
end
vim.api.nvim_create_autocmd({ "FileType" }, { pattern = { "python" }, callback = which_key_iron_repl })
