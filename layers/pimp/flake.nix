{
  inputs = {
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
      config.nvim.layers.pimp.plugins.start =
        (pkgs.flake2vim inputs [ ]) ++ [ pkgs.vimPlugins.awesome-vim-colorschemes ];
      config.nvim.layers.pimp.init.vim = ''colorscheme ${config.nvim.colorscheme}'';
    };
  };
}
    
