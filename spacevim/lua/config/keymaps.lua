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
	Util.terminal.open(
		{ require("config.directories") .. "/lazygit/bin/lazygit" },
		{ cwd = Util.root.get(), esc_esc = false }
	)
end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function()
	Util.terminal.open({ require("config.directories") .. "/lazygit/bin/lazygit" }, { esc_esc = false })
end, { desc = "Lazygit (cwd)" })

local function which_key_iron_repl()
	map("n", "<leader>r", "<CMD>IronRepl<CR>", { desc = "REPL", buffer = 0 })
	map("v", "<CR>", require("iron").core.visual_send, { desc = "Send to REPL", buffer = 0 })
	map("n", "<CR>", require("iron").core.send_line, { desc = "Send line to REPL", buffer = 0 })
end
vim.api.nvim_create_autocmd({ "FileType" }, { pattern = { "python", "nix" }, callback = which_key_iron_repl })

local lazyterm = function()
	LazyVim.terminal(nil, { cwd = LazyVim.root() })
end
map("n", "<leader>fT", lazyterm, { desc = "Terminal (Root Dir)" })
map("n", "<leader>ft", function()
	LazyVim.terminal()
end, { desc = "Terminal (cwd)" })
map("n", "<c-_>", lazyterm, { desc = "Terminal (Root Dir)" })
map("n", "<c-/>", lazyterm, { desc = "which_key_ignore" })
