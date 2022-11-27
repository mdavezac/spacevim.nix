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
  };
  options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the completion layer";
    };
    sources = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf (lib.types.submodule { options = source_options; }));
      default = { };
      description = ''
        Mapping from filtype to a list of sources.

        There are three special filetypes:
        - other: default set of sources for filetypes that are not explicitly given
        - "/": for search. Not implemented.
        - ":": for command. Not implemented.
      '';
    };
  };
in
{
  options.spacenix = lib.mkOption {
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
