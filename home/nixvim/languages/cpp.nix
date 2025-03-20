{pkgs, ...}: {
  programs.nixvim.plugins = {
    telescope.enable = true;
    cmake-tools = {
      enable = true;
      settings = {
        make_build_directory = "build/";
        cmake_soft_link_compile_commands = false;
        cmake_executor = {
          name = "quickfix";
          opts.show = "only_on_error";
        };
      };
      lazyLoad.settings = {
        ft = ["cpp" "cmake"];
        keys = [
          {
            __unkeyed-1 = "<leader>cb";
            __unkeyed-2 = "<CMD>CMakeBuild<CR>";
            desc = "Build";
          }
          {
            __unkeyed-1 = "<leader>cg";
            __unkeyed-2 = "<CMD>CMakeSettings<CR>";
            desc = "CMake Settings";
          }
          {
            __unkeyed-1 = "<leader>cS";
            __unkeyed-2 = "<CMD>CMakeStopExecutor<CR>";
            desc = "Stop CMake";
          }
          {
            __unkeyed-1 = "<leader>cc";
            __unkeyed-2 = "<CMD>CMakeSelectConfigurePreset<CR>";
            desc = "Configure CMake";
          }
          {
            __unkeyed-1 = "<leader>co";
            __unkeyed-2 = "<CMD>CMakeOpenExecutor<CR>";
            desc = "Open CMake Window";
          }
          {
            __unkeyed-1 = "<leader>cO";
            __unkeyed-2 = "<CMD>CMakeClose<CR>";
            desc = "Close CMake Window";
          }
        ];
      };
    };
    clangd-extensions = {
      enable = true;
      lazyLoad.settings.ft = "cpp";
      settings = {
        inlay_hints.inline = false;
        ast = {
          role_icons = {
            type = "";
            declaration = "";
            expression = "";
            specifier = "";
            statement = "";
            "template argument" = "";
          };
          kind_icons = {
            Compound = "";
            Recovery = "";
            TranslationUnit = "";
            PackExpansion = "";
            TemplateTypeParm = "";
            TemplateTemplateParm = "";
            TemplateParamObject = "";
          };
        };
      };
    };
    lsp.servers.cmake.enable = true;
    lsp.servers.clangd = {
      enable = true;
      onAttach.function = ''
        vim.keymap.set(
            "n",
            "<leader>cR",
            "<cmd>ClangdSwitchSourceHeader<cr>",
            {desc="Switch Header/Source"}
        )
      '';
      cmd = [
        "${pkgs.clang-tools}/bin/clangd"
        "--background-index"
        "--clang-tidy"
        "--header-insertion=iwyu"
        "--completion-style=detailed"
        "--function-arg-placeholders"
        "--fallback-style=llvm"
      ];
      filetypes = ["cpp" "c" "objc" "objcpp" "cuda"];
      extraOptions = {
        usePlaceholders = true;
        completeUnimported = true;
        clangdFileStatus = true;
      };
    };
  };
}
