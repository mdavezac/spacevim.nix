{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";

    neovim = {
      url = "github:neovim/neovim/v0.6.1?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    base-layer.url = "./layers/base";
    tree-sitter-layer = {
      url = "./layers/tree-sitter";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    pimplayer.url = "./layers/pimp";
    lsp.url = "./layers/lsp";
    languages.url = "./layers/languages";
    formatter.url = "./layers/formatter";
    git.url = "./layers/git";
    motion.url = "./layers/motion";
    terminal.url = "./layers/terminal";
    tmux.url = "./layers/tmux";
    projects.url = "./layers/projects";
    dash.url = "./layers/dash";
    testing.url = "./layers/testing";
  };

  outputs = inputs @ { self, nixpkgs, neovim, flake-utils, devshell, ... }:
    let
      layers = builtins.removeAttrs inputs [ "self" "nixpkgs" "flake-utils" "devshell" "neovim" ];
      default = (import ./.) layers;
      overlay_ = super: self: { spacenix-wrapper = (default { pkgs = super; }).customNeovim; };
      overlays_ = [
        neovim.overlay
        (final: prev: {
          python = prev.python3;
        })
        overlay_
      ] ++ (builtins.catAttrs "overlay" (builtins.attrValues layers));
    in
    {
      overlay_list = overlays_;
    } //
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ devshell.overlay ] ++ overlays_;
        };
        customNeovim = (import ./. layers { inherit pkgs; }).customNeovim;
        default_config = (import ./. layers { inherit pkgs; }).default_config;
      in
      rec {
        defaultPackage = customNeovim default_config;
        apps = {
          nvim = flake-utils.lib.mkApp {
            drv = defaultPackage;
            name = "nvim";
          };
          repl = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "repl" ''
              confnix=$(mktemp)
              echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
              trap "rm $confnix" EXIT
              nix repl $confnix
            '';
          };
        };

        wrapper = customNeovim;
        defaultApp = apps.nvim;

        devShell = pkgs.devshell.mkShell {
          name = "neovim";
          packages = [ defaultPackage ];

          commands = [
            {
              name = "vim";
              command = "${defaultPackage}/bin/nvim";
              help = "alias for neovim with spacenix config";
            }
            {
              name = "vi";
              command = "${defaultPackage}/bin/nvim";
              help = "alias for neovim with spacenix config";
            }
          ];
        };
      }
    );
}
