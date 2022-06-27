{ config, lib, pkgs, ... }: {
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.languages = lib.mkOption {
        type = lib.types.submodule {
          options.python = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the python language layer";
          };
          options.nix = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the nix language layer";
          };
          options.markdown = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable the markdown language layer";
          };
        };
        default = { };
      };
    };
  };
  imports = [ ./nix.nix ./python.nix ./markdown.nix ];
  config.nvim.plugins.start = [ pkgs.vimPlugins.vim-commentary ];
}
