{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    let
      overlay_ = (self: super: {
        vimPlugins = super.vimPlugins // {
          nvim-treesitter = self.vimUtils.buildVimPluginFrom2Nix {
            pname = "nvim-treesitter";
            version = inputs.nvim-treesitter.shortRev;
            src = inputs.nvim-treesitter;
          };
        };
      });
    in
    {
      overlay = overlay_;
      module = { config, lib, pkgs, ... }: {
        imports = [ ./options.nix ./config.nix ./keys.nix ];
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ overlay_ ];
        };
      in
      {
        defaultPackage = pkgs.callPackage (import ./tree-sitter.nix) {
          languages = [ "python" ];
          nvim-treesitter-src = pkgs.vimPlugins.nvim-treesitter;
        };
      });
}
