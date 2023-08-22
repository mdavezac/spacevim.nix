local M = {}
local function fullsetup()
	local os = require("os")
	local specs = {
		-- add LazyVim and import its plugins
		{
			"LazyVim/LazyVim",
			name = "LazyVim",
			import = "lazyvim.plugins",
			dir = require("config.directories") .. "/LazyVim",
			pin = true,
		},
		-- import any extras modules here
		{ import = "lazyvim.plugins.extras.test.core" },
		-- import/override with your plugins
		{ import = "plugins" },
		{ import = "config.localproject" },
		{ import = "config.with_nix" },
	}

	local opts = {
		spec = specs,
		defaults = {
			-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
			-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
			lazy = false,
			-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
			-- have outdated releases, which may break your Neovim install.
			version = false, -- always use the latest git commit
			-- version = "*", -- try installing the latest stable version for plugins that support semver
		},
		checker = { enabled = false }, -- automatically check for plugin updates
		performance = {
			rtp = {
				-- disable some rtp plugins
				disabled_plugins = {
					"gzip",
					"tarPlugin",
					"tohtml",
					"tutor",
					"zipPlugin",
				},
			},
		},
		ui = { icons = { lazy = "💤" } },
	}
	if os.getenv("LAZY_NIX_ROOT") then
		opts.root = os.getenv("LAZY_NIX_ROOT") .. "/data"
		opts.lockfile = os.getenv("LAZY_NIX_ROOT") .. "/lazy-lock.json"
		opts.readme = {
			root = os.getenv("LAZY_NIX_ROOT") .. "/state/readme",
		}
		opts.state = os.getenv("LAZY_NIX_ROOT") .. "/state.json"
	end
	require("lazy").setup(opts)
end

local function flattensetup()
	local path = require("config.directories") .. "/flatten.nvim"
	require("lazy").setup({ { "willothy/flatten.nvim", config = true, dir = path } })
end

if os.getenv("NVIM") ~= nil then
	M.setup = flattensetup
else
	M.setup = fullsetup
end
return M
