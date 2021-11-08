{
  inputs = {
    navigator = { url = "github:numToStr/Navigator.nvim"; flake = false; };
  };
  outputs = { self, ... }: {
    overlay = (self: super: {
      vimPlugins = super.vimPlugins // {
        navigator = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "navigator";
          version = inputs.navigator.shortRev;
          src = inputs.navigator;
        };
      };
    });

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

      config.nvim.plugins.start = lib.mkIf [ pkgs.vimPlugins.navigator ];
      config.nvim.init.lua = lib.mkIf config.nvim.layers.tmux.enable ''
        require('Navigator').setup({disable_on_zoom=true})
      '';
    };
  };
}
