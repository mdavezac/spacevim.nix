{ lib, ... }:
let
  options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the debugger layer";
    };
  };
in
{
  options.spacenix = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.debugger = lib.mkOption {
            type = lib.types.submodule { options = options; };
            default = { };
          };
        };
      };
    };
  };
}
