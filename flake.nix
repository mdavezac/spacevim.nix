{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    base-layer.url = "./layers/base";
    tree-sitter-layer.url = "./layers/tree-sitter";
    pimplayer.url = "./layers/pimp";
    lsp.url = "./layers/lsp";
    languages.url = "./layers/languages";
    formatter.url = "./layers/formatter";
  };

  outputs = inputs @ { self, nixpkgs, neovim, flake-utils, devshell, ... }:
    let
      layers = builtins.removeAttrs inputs [ "self" "nixpkgs" "flake-utils" "devshell" "neovim" ];
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [
            devshell.overlay
            neovim.overlay
            (final: prev: {
              python = prev.python3;
            })
          ] ++ (builtins.catAttrs "overlay" (builtins.attrValues layers));
        };
        customNeovim = pkgs: configuration:
          let
            vim-plugin-from-key-value-pair = k: v: pkgs.vimUtils.buildVimPluginFrom2Nix {
              pname = k;
              version = "master";
              src = v;
            };
            plugins = inputs: exclude: builtins.attrValues (
              builtins.mapAttrs
                vim-plugin-from-key-value-pair
                (builtins.removeAttrs inputs ([ "self" "nixpkgs" ] ++ exclude))
            );
            layer_modules = builtins.map
              (x: if (builtins.isAttrs x) then (builtins.getAttr system x) else x)
              (builtins.catAttrs "module" (builtins.attrValues layers));
            module = pkgs.lib.evalModules {
              modules = [ ./layers/module.nix { _module.args.pkgs = pkgs // { flake2vim = plugins; }; } ]
                ++ layer_modules
                ++ [ configuration ];
            };
          in
          pkgs.wrapNeovim pkgs.neovim {
            configure = {
              customRC =
                module.config.nvim.init.vim
                + ("\n\nlua <<EOF\n" + module.config.nvim.init.lua + "\nEOF\n\n")
                + module.config.nvim.post.vim
                + ("\n\nlua <<EOF\n" + module.config.nvim.post.lua + "\nEOF");
              packages.spacevimnix = {
                start = module.config.nvim.plugins.start;
                opt = [ ];
              };
            };
          };
        configuration.nvim = {
          layers.base = true;
          layers.treesitter = true;
          layers.pimp = true;
          layers.lsp = true;
          layers.formatter = false;
          layers.python = true;
          layers.nix = true;
          # init.lua = "${placeholder "out"}";
        };
      in
      rec {
        overlay = super: self: {
          spacevim-nix-wrapper = customNeovim super;
        };
        defaultPackage = customNeovim pkgs configuration;
        apps = {
          nvim = flake-utils.lib.mkApp {
            drv = defaultPackage;
            name = "nvim";
          };
        };

        defaultApp = apps.nvim;

        devShell = pkgs.devshell.mkShell {
          name = "neovim";
          packages = [ defaultPackage ];

          commands = [
            {
              name = "vim";
              command = "${defaultPackage}/bin/nvim";
              help = "alias for neovim with neovitality config";
            }
            {
              name = "vi";
              command = "${defaultPackage}/bin/nvim";
              help = "alias for neovim with neovitality config";
            }
          ];
        };
      }
    );
}
