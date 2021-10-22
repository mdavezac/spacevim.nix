{
  inputs = {
    which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    plenary = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    telescope = { url = "github:/nvim-telescope/telescope.nvim"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ { self, flake-utils, ... }:
    let
      vim-plugin-from-key-value-pair = nixpkgs: k: v: nixpkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = k;
        version = "master";
        src = v;
      };
      plugins = nixpkgs: builtins.attrValues (
        builtins.mapAttrs
          (vim-plugin-from-key-value-pair nixpkgs)
          (builtins.removeAttrs inputs [ "self" "flake-utils" "nixpkgs" ])
      );
    in
    {
      overlay = final: prev: {
        layers.base.plugins.start = plugins final;
      };
      module = { config, pkgs, ... }: {
        config.nvim.layers.base.enable = true;
        config.nvim.layers.base.plugins.start = pkgs.layers.base.plugins.start;
        config.nvim.layers.base.init.lua = builtins.readFile ./init.lua;
      };
    };
}
    