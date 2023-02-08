{lib, ...}: let
  options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the neorg layer";
    };
    gtd = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Get things done workspace";
    };
    workspaces = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options.path = lib.mkOption {
          type = lib.types.str;
          description = "Path to the workspace";
        };
        options.name = lib.mkOption {
          type = lib.types.str;
          description = "Name for the workspace";
        };
        options.key = lib.mkOption {
          type = lib.types.str;
          description = "Key associated with the workspace";
        };
      });
      default = [];
      description = "List of workspaces";
    };
  };
in {
  options.spacenix = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.neorg = lib.mkOption {
            type = lib.types.submodule {
              options = options;
            };
            default = {};
          };
        };
      };
    };
  };
}
