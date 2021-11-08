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
    git.url = "./layers/git";
    motion.url = "./layers/motion";
    terminal.url = "./layers/terminal";
    tmux.url = "./layers/tmux";
    projects.url = "./layers/projects";
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
      overlays = overlays_;
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
