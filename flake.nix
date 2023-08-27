{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    lazy-nvim.url = "github:folke/lazy.nvim";
    lazy-nvim.flake = false;
    lazy-dist.url = "github:LazyVim/LazyVim";
    lazy-dist.flake = false;
    iron-nvim.url = "github:hkupty/iron.nvim";
    iron-nvim.flake = false;
    nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    nvim-lspconfig.flake = false;
    neotest-nvim.url = "github:nvim-neotest/neotest";
    neotest-nvim.flake = false;
    neotest-python-nvim.url = "github:nvim-neotest/neotest-python";
    neotest-python-nvim.flake = false;
    flatten-nvim.url = "github:willothy/flatten.nvim";
    flatten-nvim.flake = false;

    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
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
          (import ./spacevim/overlays/plugins.nix ({lib = pkgs.lib;} // inputs))
        ];
      };
    in rec {
      packages.nvim = (import ./spacevim) {inherit pkgs;};
      packages.tmux = (import ./tmux) {inherit pkgs;};
      packages.git = (import ./git) {inherit pkgs;};
      apps = let
        make = name:
          flake-utils.lib.mkApp {
            drv = builtins.getAttr name packages;
            name = name;
          };
      in rec {
        nvim = make "nvim";
        tmux = make "tmux";
        git = make "git";
      };

      devShells.default = pkgs.devshell.mkShell {
        name = "neovim";
        imports = [];
      };
    };
  in
    flake-utils.lib.eachDefaultSystem systemized;
}
