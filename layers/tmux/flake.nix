{
  inputs = { };
  outputs = inputs @ { self, ... }: {
    module = { config, lib, pkgs, ... }: {
      imports = [ ./keys.nix ];

      options.nvim = lib.mkOption {
        type = lib.types.submodule {
          options.layers = lib.mkOption {
            type = lib.types.submodule {
              options.tmux = lib.mkOption {
                type = lib.types.submodule {
                  options.enable = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Whether to enable the tmux layer";
                  };
                };
                default = { };
              };
            };
          };
        };
      };

      config.nvim.plugins.start = lib.mkIf config.nvim.layers.tmux.enable [
        pkgs.vimPlugins.vim-tmux-navigator
      ];
      config.nvim.init.vim = lib.mkIf config.nvim.layers.tmux.enable ''
        let g:tmux_navigator_no_mappings = 1
        let g:tmux_navigator_disable_when_zoomed = 1
      '';
    };
  };
}
