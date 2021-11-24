{ lib, ... }:
let
  formatter-option = lib.types.submodule ({
    options.enable = lib.mkEnableOption "Whether to run this specific formatter";
    options.filetype = lib.mkOption {
      type = lib.types.str;
      description = "Filetype for which to run this formatter";
    };
    options.exe = lib.mkOption {
      type = lib.types.str;
      description = "Binary to call for formatting";
    };
    options.args = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of command-line arguments for the formatter";
      default = [ ];
    };
    options.stdin = lib.mkOption {
      type = lib.types.bool;
      description = "Whether the formatter can use stdin";
      default = true;
    };
  });
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.formatter = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the formatter layer";
              };
            };
            default = { };
          };
        };
      };
      options.formatters = lib.mkOption {
        type = lib.types.attrsOf formatter-option;
        description = ''Dictionary of formatter configurations.'';
        default = { };
      };
      options.format-on-save = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''List of filetypes for which to run format-on-save'';
        default = [ ];
        example = ''["*.py"]'';
      };
    };
  };
}
