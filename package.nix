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
    name = "pytools";
    paths = [pkgs.rust-analyzer];
  };
  lazy-nix = let
    packages = pkgs.linkFarm "vim-plugins" [
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
        name = "toggleterm.nvim";
        path = pkgs.vimPlugins.toggleterm-nvim;
      }
      {
        name = "iron.nvim";
        path = pkgs.vimPlugins.iron-nvim;
      }
      {
        name = "bufferline";
        path = pkgs.vimPlugins.bufferline-nvim;
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
        name = "flatten.nvim";
        path = pkgs.vimPlugins.flatten-nvim;
      }
      {
        name = "rust-tools";
        path = pkgs.vimPlugins.rust-tools-nvim;
      }
      {
        name = "rust";
        path = rust;
      }
    ];
  in
    pkgs.vimUtils.buildVimPluginFrom2Nix {
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
  pkgs.wrapNeovim pkgs.neovim {
    configure = {
      customRC = ''
        lua require('config.lazyentry').setup()
      '';
      packages.lazy = {
        start = [distribution];
      };
    };
  }
