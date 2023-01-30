{ config, lib, pkgs, ... }: {

  options.spacenix = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.dash = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = (pkgs.system == "x86_64-darwin");
                description = "Whether to enable the dash layer";
              };
            };
            default = { };
          };
        };
      };
      options.dash = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf lib.types.str);
        description = "Dash keywords associated with a filetype";
        default = { };
      };
    };
  };
}
