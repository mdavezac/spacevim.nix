{pkgs}: let
  treesitter = (pkgs.callPackage ./treesitter.nix) {};
  luasnip = pkgs.buildEnv {
    name = "luasnip";
    paths = [pkgs.vimPlugins.luasnip pkgs.luajitPackages.jsregexp];
  };
  cpptools = pkgs.buildEnv {
    name = "cpptools";
    paths = [pkgs.cmake-language-server pkgs.clang-tools];
  };
  pytools = pkgs.buildEnv {
    name = "pytools";
    paths = [pkgs.nodePackages.pyright pkgs.black pkgs.isort];
  };
  rust = pkgs.buildEnv {
    name = "rusttools";
    paths = [pkgs.rust-analyzer];
  };
  json = pkgs.buildEnv {
    name = "jsontools";
    paths = [pkgs.vscode-langservers-extracted];
  };
  lazy-nix = let
    get-plugin = x: builtins.getAttr (builtins.replaceStrings [".nvim"] ["-nvim"] x) pkgs.vimPlugins;
    make-plugin2 = x: {
      name = x;
      path = get-plugin x;
    };
    make-plugin = a: b: {
      name = a;
      path = builtins.getAttr b pkgs.vimPlugins;
    };
    packages = pkgs.linkFarm "vim-plugins" [
      {
        name = "deno";
        path = pkgs.deno;
      }
      {
        name = "LuaSnip";
        path = luasnip;
      }
      {
        name = "nvim-treesitter";
        path = treesitter;
      }
      {
        name = "stylua";
        path = pkgs.stylua;
      }
      {
        name = "shfmt";
        path = pkgs.shfmt;
      }
      {
        name = "alejandra";
        path = pkgs.alejandra;
      }
      {
        name = "luals";
        path = pkgs.sumneko-lua-language-server;
      }
      {
        name = "rnix";
        path = pkgs.rnix-lsp;
      }
      {
        name = "pytools";
        path = pytools;
      }
      {
        name = "cpp";
        path = cpptools;
      }
      {
        name = "lazygit";
        path = pkgs.lazygit;
      }
      {
        name = "LazyVim";
        path = pkgs.vimPlugins.lazy-dist;
      }
      {
        name = "neotest";
        path = pkgs.vimPlugins.neotest-nvim;
      }
      {
        name = "neotest-python";
        path = pkgs.vimPlugins.neotest-python-nvim;
      }
      {
        name = "shfmt";
        path = pkgs.shfmt;
      }
      {
        name = "rust-tools";
        path = pkgs.vimPlugins.rust-tools-nvim;
      }
      {
        name = "rust";
        path = rust;
      }
      {
        name = "json";
        path = json;
      }
      {
        name = "rg";
        path = pkgs.ripgrep;
      }
      {
        name = "telescope.nvim";
        path = pkgs.vimPlugins.telescope-nvim;
      }
      (make-plugin2 "telescope-fzf-native.nvim")
      (make-plugin2 "telescope.nvim")
      (make-plugin2 "toggleterm.nvim")
      (make-plugin2 "iron.nvim")
      (make-plugin2 "bufferline.nvim")
      (make-plugin2 "nvim-cmp")
      (make-plugin2 "flatten.nvim")
      (make-plugin2 "nvim-cmp")
      (make-plugin "cmp-buffer" "cmp-buffer-nvim")
      (make-plugin "cmp-nvim-lsp" "cmp-lsp-nvim")
      (make-plugin "cmp-path" "cmp-path-nvim")
      (make-plugin "cmp_luasnip" "cmp-luasnip-nvim")
      (make-plugin2 "nui.nvim")
      (make-plugin2 "noice.nvim")
      (make-plugin2 "lualine.nvim")
      (make-plugin2 "which-key.nvim")
      (make-plugin2 "dressing.nvim")
      (make-plugin2 "conform.nvim")
      (make-plugin2 "trouble.nvim")
    ];
  in
    pkgs.vimUtils.buildVimPlugin {
      pname = "lazy-nix";
      version = "0.0.0";
      src = [./lua ./ftplugin];
      sourceRoot = ".";
      buildPhase = ''
        echo  "return '${packages}'" > lua/config/directories.lua
      '';
    };
  lazy-nvim = pkgs.vimPlugins.lazy-nvim.overrideAttrs (finalAttrs: previousAttrs: {
    depsBuildInput = [pkgs.neovim];
    buildPhase = ''
      ${pkgs.neovim}/bin/nvim -i NONE --clean -V -e ":helptags doc" -es +q
    '';
  });
  distribution = pkgs.symlinkJoin {
    name = "LazyNvim";
    paths = [lazy-nvim lazy-nix];
  };
in
  pkgs.wrapNeovim pkgs.neovim-unwrapped {
    configure = {
      customRC = ''
        lua require('config.lazyentry').setup()
      '';
      packages.lazy = {
        start = [distribution];
      };
    };
  }
