{ lib, ... }:
let
  source_options = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Name of the source";
    };
    priority = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Priority of the source";
    };
    group_index = lib.mkOption {
      type = lib.types.int;
      default = 1;
    };
    filetypes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "all" ];
      description = "Which filetypes for which to enable the completion source";
    };
  };
  options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the completion layer";
    };
    sources = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule { options = source_options; });
      default = [ ];
      description = "Potential sources";
    };
  };
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.completion = lib.mkOption {
            type = lib.types.submodule { options = options; };
            default = { };
          };
        };
      };
    };
  };
}
