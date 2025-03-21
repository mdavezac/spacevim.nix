local codelldb = "codelldb"
if vim.loop.os_uname().sysname ~= "Darwin" then
	codelldb = require("config.directories") .. "/cpp/bin/codelldb"
end
return {
	{
		"p00f/clangd_extensions.nvim",
		ft = { "cpp", "c" },
		lazy = true,
		config = function() end,
		opts = {
			extensions = {
				inlay_hints = {
					inline = false,
				},
				ast = {
					--These require codicons (https://github.com/microsoft/vscode-codicons)
					role_icons = {
						type = "",
						declaration = "",
						expression = "",
						specifier = "",
						statement = "",
						["template argument"] = "",
					},
					kind_icons = {
						Compound = "",
						Recovery = "",
						TranslationUnit = "",
						PackExpansion = "",
						TemplateTypeParm = "",
						TemplateTemplateParm = "",
						TemplateParamObject = "",
					},
				},
			},
		},
	},

	-- Correctly setup lspconfig for clangd 🚀
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				cmake = { cmd = { require("config.directories") .. "/cpp/bin/cmake-language-server" } },
				clangd = {
					keys = {
						{ "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
					},
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
					cmd = {
						require("config.directories") .. "/cpp/bin/clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},
				},
			},
		},
	},
	{
		"nvim-cmp",
		opts = function(_, opts)
			table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
		end,
	},
	{
		"Civitasv/cmake-tools.nvim",
		opts = {
			cmake_build_options = { "--parallel", "4" },
			cmake_soft_link_compile_commands = false,
			cmake_executor = {
				name = "quickfix",
				opts = {
					show = "only_on_error",
				},
			},
		},
		ft = { "cmake", "cpp" },
		keys = {
			{ "<leader>cb", "<CMD>CMakeBuild<CR>", desc = "Build" },
			{ "<leader>cg", "<CMD>CMakeSettings<CR>", desc = "CMake Settings" },
			{ "<leader>cS", "<CMD>CMakeStopExecutor<CR>", desc = "Stop CMake" },
			{ "<leader>cC", "<CMD>CMakeSelectConfigurePreset<CR>", desc = "CMake Configure" },
			{ "<leader>cq", "<CMD>CMakeClose<CR>", desc = "Close CMake Window" },
			{ "<leader>co", "<CMD>CMakeOpenExecutor<CR>", desc = "Open CMake Window" },
		},
	},
	{
		"nvim-neotest/neotest",
		ft = { "cpp" },
		opts = {
			adapters = {
				["neotest-gtest"] = {},
			},
		},
		dependencies = { "alfaix/neotest-gtest" },
	},
	{ "alfaix/neotest-gtest", ft = { "cpp" } },
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")
			if not dap.adapters["codelldb"] then
				require("dap").adapters["codelldb"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = codelldb,
						args = {
							"--port",
							"${port}",
						},
					},
				}
			end
			for _, lang in ipairs({ "c", "cpp" }) do
				dap.configurations[lang] = {
					{
						type = "codelldb",
						request = "launch",
						name = "Launch file",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
					},
					{
						type = "codelldb",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { cpp = { "clang-format" } },
			formatters = {
				["clang-format"] = { command = require("config.directories") .. "/cpp/bin/clang-format" },
			},
		},
	},
}
