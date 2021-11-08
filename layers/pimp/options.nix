{ config, lib, pkgs, ... }: {
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.colorscheme = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''Colorschemes'';
      };
      options.background = lib.mkOption {
        type = lib.types.enum ["dark" "light"];
        default = "dark";
        description = ''Background'';
      };
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.pimp = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the pimp layer";
              };
              options.notify = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the notify plugin";
              };
              options.statusline = lib.mkOption {
                type = lib.types.enum [ "lualine" ];
                default = "lualine";
                description = "Statusline plugin";
              };
              options.tabline = lib.mkOption {
                type = lib.types.enum [ "barbar" ];
                default = "barbar";
                description = "Tabline plugin";
              };
            };
            default = { };
          };
        };
      };
    };
  };
}
