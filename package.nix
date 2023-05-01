{pkgs}: let
  treesitter = pkgs.buildEnv {
    name = "nvim-treesitter";
    paths = let
      grammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.passthru.dependencies;
      filtered = builtins.filter (x: x.name != "nvim-treesitter-help-grammar") grammars;
    in
      [pkgs.vimPlugins.nvim-treesitter] ++ filtered;
  };
  luasnip = pkgs.buildEnv {
    name = "luasnip";
    paths = [pkgs.vimPlugins.luasnip pkgs.luajitPackages.jsregexp];
  };
  cpptools = pkgs.buildEnv {
    name = "cpptools";
    paths = [pkgs.cmake-language-server pkgs.clang-tools];
  };
  lazy-nix = let
    packages = pkgs.linkFarm "vim-plugins" [
      {
        name = "luasnip";
        path = luasnip;
      }
      {
        name = "treesitter";
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
        name = "pyright";
        path = pkgs.nodePackages.pyright;
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
        name = "lazy-dist";
        path = pkgs.vimPlugins.lazy-dist;
      }
      {
        name = "toggleterm";
        path = pkgs.vimPlugins.toggleterm-nvim;
      }
      {
        name = "iron";
        path = pkgs.vimPlugins.iron-nvim;
      }
    ];
  in
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "lazy-nix";
      version = "0.0.0";
      src = ./lua;
      buildPhase = ''
        mkdir lua/
        mv config plugins lua

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
        lua require('config.lazy').setup()
      '';
      packages.lazy = {
        start = [distribution];
      };
    };
  }
