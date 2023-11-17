return {
	{
		"p00f/clangd_extensions.nvim",
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
				cmake = { cmd = { require("config.directories") .. "/cpp/bin/neocmakelsp", "--stdio" } },
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
		keys = {
			{ "<leader>cb", "<CMD>CMakeBuild<CR>", desc = "Build" },
			{ "<leader>cs", "<CMD>CMakeSettings<CR>", desc = "CMake Settings" },
			{ "<leader>cS", "<CMD>CMakeStop<CR>", desc = "Stop CMake" },
			{ "<leader>cc", "<CMD>CMakeSelectConfigurePreset<CR>", desc = "CMake Configure" },
			{ "<leader>cq", "<CMD>CMakeClose<CR>", desc = "Close CMake Window" },
			{ "<leader>co", "<CMD>CMakeOpen<CR>", desc = "Open CMake Window" },
		},
	},
}
