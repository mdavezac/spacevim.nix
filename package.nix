{pkgs}: let
  treesitter = pkgs.buildEnv {
    name = "nvim-treesitter";
    paths = let
      langs = p: [
        p.c
        p.cpp
        p.python
        p.rust
        p.javascript
        p.nix
        p.cmake
        p.yaml
        p.json
        p.jsonc
        p.json5
        p.julia
        p.haskell
        p.racket
        p.r
        p.nickel
      ];
      ts = l: (pkgs.vimPlugins.nvim-treesitter.withPlugins l).passthru.dependencies;
    in
      [pkgs.vimPlugins.nvim-treesitter] ++ (ts langs);
  };
  luasnip = pkgs.buildEnv {
    name = "luasnip";
    paths = [pkgs.vimPlugins.luasnip pkgs.luajitPackages.jsregexp];
  };
  lazy-nix = let
    packages = pkgs.linkFarm "vim-plugins" [
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

        cat >lua/config/directories.lua <<EOF
        return '${packages}'
        EOF

        cat > lua/plugins/hardcoded.lua <<EOF
        return {
          { "nvim-treesitter/nvim-treesitter", name="nvim-treesitter",
            dir='${treesitter}', pin=true, opts = { ensure_installed = {} }, },
          { "L3MON4D3/LuaSnip", name="LuaSnip", dir='${luasnip}', pin=true },
        }
        EOF
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
