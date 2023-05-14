local function list_plugins(directory, plugins)
	local pinned = {}
	for _, plugin in pairs(plugins) do
		local path = directory:gsub("/+$", "") .. "/" .. plugin.name
		local stat_path = vim.loop.fs_lstat(path)
		if stat_path ~= nil then
			pinned[#pinned + 1] = { plugin[1], name = plugin.name, dir = path }
		end
	end
	return pinned
end
local plugins = {
	{ "L3MON4D3/LuaSnip", name = "LuaSnip" },
	{ "akinsho/toggleterm.nvim", name = "toggleterm.nvim" },
	{ "nvim-neotest/neotest", name = "neotest" },
	{ "nvim-neotest/neotest-python", name = "neotest-python" },
	{ "Vigemus/iron.nvim", name = "iron.nvim" },
	{ "LazyVim/LazyVim", name = "LazyVim" },
}
return list_plugins(require("config.directories"), plugins)
