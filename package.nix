{pkgs}: let
  treesitter = pkgs.buildEnv {
    name = "nvim-treesitter";
    paths = [pkgs.vimPlugins.nvim-treesitter] ++ pkgs.vimPlugins.nvim-treesitter.withAllGrammars.passthru.dependencies;
  };
  luasnip = pkgs.buildEnv {
    name = "luasnip";
    paths = [pkgs.vimPlugins.luasnip pkgs.luajitPackages.jsregexp];
  };
  lazy-nix = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "lazy-nix";
    version = "0.0.0";
    src = ./lua;
    buildPhase = ''
      mkdir lua/
      mv config plugins lua

      cat >lua/config/directories.lua <<EOF
      return {
          stylua = '${pkgs.stylua}/bin/stylua',
          shfmt = '${pkgs.shfmt}/bin/shfmt',
          alejandra = '${pkgs.alejandra}/bin/alejandra',
          lua_ls = '${pkgs.sumneko-lua-language-server}/bin/lua-language-server',
          pyright = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"},
          lazygit = "${pkgs.lazygit}/bin/lazygit"
      }
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
    depsBuildInput = [pkgs.neovim lazy-nix];
    buildPhase = ''
      cp -r ${lazy-nix}/lua/* lua
      ${pkgs.neovim}/bin/nvim -i NONE --clean -V -e ":helptags doc" -es +q
    '';
  });
in
  pkgs.wrapNeovim pkgs.neovim {
    configure = {
      customRC = ''
        lua require("config.directories").lazydir = '${pkgs.vimPlugins.lazy-dist}'
        lua require('config.lazy').setup('${pkgs.vimPlugins.lazy-dist}')
      '';
      packages.lazy = {
        start = [lazy-nvim];
      };
    };
  }
