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
      config.nvim.plugins.start = lib.mkIf config.nvim.layers.pimp
        ((pkgs.flake2vim inputs [ ]) ++ [ pkgs.vimPlugins.awesome-vim-colorschemes ]);
      config.nvim.init.vim = lib.mkIf config.nvim.layers.pimp
        ''
          " Pimp layer
          colorscheme ${config.nvim.colorscheme}
          " End of pimp layer
        '';
    };
  };
}
    
