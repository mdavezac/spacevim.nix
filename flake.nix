{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    lazy-nvim.url = "github:folke/lazy.nvim";
    lazy-nvim.flake = false;
    lazy-dist.url = "github:LazyVim/LazyVim";
    lazy-dist.flake = false;

    neovim = {
      url = "github:neovim/neovim/v0.8.3?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    neovim,
    flake-utils,
    devshell,
    ...
  }: let
    systemized = system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [
          devshell.overlays.default
          neovim.overlay
          (import ./overlays/plugins.nix ({lib = pkgs.lib;} // inputs))
        ];
      };
    in rec {
      packages.default = (import ./package.nix) {inherit pkgs;};
      apps = rec {
        nvim = flake-utils.lib.mkApp {
          drv = packages.default;
          name = "nvim";
        };
        default = nvim;
      };

      devShells.default = pkgs.devshell.mkShell {
        name = "neovim";
        imports = [];
      };
    };
  in
    flake-utils.lib.eachDefaultSystem systemized;
}
