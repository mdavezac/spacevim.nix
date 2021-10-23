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
          ];
        };
        customNeovim = pkgs: configuration:
          let
            module = pkgs.lib.evalModules {
              modules = [ ./layers/module.nix { _module.args.pkgs = pkgs; } ]
                ++ (builtins.catAttrs "module" (builtins.attrValues layers))
                ++ [ configuration ];
            };
          in
          pkgs.wrapNeovim pkgs.neovim {
            configure = {
              customRC = "lua <<EOF\n" + module.config.nvim.init.lua + "\nEOF";
              packages.spacevimnix = {
                start = module.config.nvim.plugins.start;
                opt = [ ];
              };
            };
          };
        configuration.nvim = {
          layers.base.enable = true;
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
          packages = [ pkgs.neovim pkgs.devshell.cli ];

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
