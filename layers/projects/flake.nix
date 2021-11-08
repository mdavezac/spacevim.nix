{
  inputs = { };
  outputs = inputs @ { self, ... }: {
    module = { config, lib, pkgs, ... }: {
      imports = [ ./keys.nix ];

      options.nvim = lib.mkOption {
        type = lib.types.submodule {
          options.layers = lib.mkOption {
            type = lib.types.submodule {
              options.projects = lib.mkOption {
                type = lib.types.submodule {
                  options.enable = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Whether to enable the project management layer";
                  };
                };
                default = { };
              };
            };
          };
        };
      };

      config.nvim.plugins.start = lib.mkIf config.nvim.layers.tmux.enable [
        pkgs.vimPlugins.auto-session
      ];
      config.nvim.init.lua = lib.mkIf config.nvim.layers.tmux.enable ''
        vim.o.sessionoptions="blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal"
        require('auto-session').setup {
          log_level = 'info',
          auto_session_suppress_dirs = {'~/'}
          auto_session_allowed_dirs = {'~/personal', '~/kagenova'}
        }
      '';
    };
  };
}
