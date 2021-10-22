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
  };

  outputs = inputs @ { self, nixpkgs, neovim, flake-utils, devshell, ... }:
    let
      layers = builtins.removeAttrs inputs [ "self" "nixpkgs" "flake-utils" "devshell" ];
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        get_from_layers = name: builtins.catAttrs name (builtins.attrValues layers);
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [
            devshell.overlay
            neovim.overlay
            (final: prev: {
              python = prev.python3;
            })
          ] ++ (get_from_layers "overlay");
        };
        module = pkgs.lib.evalModules {
          modules = [ ./layers/module.nix { _module.args.pkgs = pkgs; } ] ++ (get_from_layers "module");
        };
      in
      rec {
        defaultPackage = pkgs.wrapNeovim pkgs.neovim
          {
            configure = {
              customRC = "lua <<EOF\n" + module.config.nvim.init.lua + "\nEOF";
              packages.myVimPackage = {
                start = module.config.nvim.plugins.start;
                opt = [ ];
              };
            };
          };

        apps = {
          nvim = flake-utils.lib.mkApp {
            drv = defaultPackage;
            name = "nvim";
          };
        };

        defaultApp = apps.nvim;

        devShell = pkgs.devshell.mkShell {
          name = "neovim";
          packages = [ pkgs.neovim pkgs.tree-sitter pkgs.devshell.cli ];

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
