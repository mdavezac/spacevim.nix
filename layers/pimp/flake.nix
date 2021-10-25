{
  inputs = {
    colorschemes = { url = "github:rafi/awesome-vim-colorschemes"; flake = false; };
    rainglow = { url = "github:rainglow/vim"; flake = false; };
  };
  outputs = inputs @ { self, ... }: rec {
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
      config.nvim.layers.pimp.plugins.start = pkgs.flake2vim inputs [ ];
      config.nvim.layers.pimp.init.vim = ''colorscheme ${config.nvim.colorscheme}'';
    };
  };
}
    
