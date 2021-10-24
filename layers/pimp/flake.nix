{
  inputs = {
    colorschemes = { url = "github:rafi/awesome-vim-colorschemes"; flake = false; };
    rainglow = { url = "github:rainglow/vim"; flake = false; };
  };
  outputs = inputs @ { self, ... }:
    let
      vim-plugin-from-key-value-pair = nixpkgs: k: v: nixpkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = k;
        version = v.shortRev;
        src = v;
      };
      plugins = nixpkgs: builtins.attrValues (
        builtins.mapAttrs
          (vim-plugin-from-key-value-pair nixpkgs)
          (builtins.removeAttrs inputs [ "self" "nixpkgs" ])
      );
    in
    rec {
      module = { config, lib, pkgs, ... }: {
        options.nvim = lib.mkOption {
          type = lib.types.submodule {
            options.colorscheme = lib.mkOption {
              type = lib.types.str;
              default = "onehalfdark";
              description = ''Colorschemes'';
            };
          };
        };
        config.nvim.layers.pimp.plugins.start = plugins pkgs;
        config.nvim.layers.pimp.init.vim = ''colorscheme ${config.nvim.colorscheme}'';
      };
    };
}
    
