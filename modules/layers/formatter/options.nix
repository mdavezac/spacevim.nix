{ lib, config, pkgs, ... }:
let
  formatter-option = { enable ? false, filetype, exe, args ? [ ], stdin ? true }: lib.mkOption {
    type = lib.types.submodule {
      options.enable = lib.mkOption {
        type = lib.types.bool;
        default = enable;
        description = "Whether to run this specific formatter";
      };
      options.filetype = lib.mkOption {
        type = lib.types.str;
        default = filetype;
        description = "Filetype for which to run this formatter";
      };
      options.exe = lib.mkOption {
        type = lib.types.str;
        description = "Binary to call for formatting";
        default = exe;
      };
      options.args = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of command-line arguments for the formatter";
        default = args;
      };
      options.stdin = lib.mkOption {
        type = lib.types.bool;
        description = "Whether the formatter can use stdin";
        default = stdin;
      };
    };
    default = { };
  };
in
{
  options.spacenix = lib.mkOption {
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
        type = lib.types.submodule {
          options.black = formatter-option {
            exe = "${pkgs.black}/bin/black";
            enable = config.spacenix.languages.python;
            args = [ "-q" "-" ];
            filetype = "python";
          };
          options.isort = formatter-option {
            exe = "${pkgs.python39Packages.isort}/bin/isort";
            enable = config.spacenix.languages.python;
            args = [ "-" ];
            filetype = "python";
          };
          options.rustfmt = formatter-option {
            exe = "${pkgs.rustfmt}/bin/rustfmt";
            enable = config.spacenix.languages.rust;
            filetype = "rust";
          };
          options.nixpkgs-fmt = formatter-option {
            exe = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            enable = false;
            filetype = "nix";
          };
          options.alejandra = formatter-option {
            exe = "${pkgs.alejandra}/bin/alejandra";
            enable = config.spacenix.languages.nix;
            filetype = "nix";
            args = [ "-q" ];
          };
        };
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
