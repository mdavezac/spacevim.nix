{ config, lib, pkgs, ... }:
let
  languages =
    builtins.attrNames (lib.importJSON "${pkgs.vimPlugins.nvim-treesitter.src}/lockfile.json");
  treesitter-option = lib.mkOption {
    type = lib.types.listOf (lib.types.enum languages);
    description = ''
      List of languages for which to build treesitter parsers.

      Only the set of "maintained" languages are supported here.
    '';
    example = [ "nix" "python" "C" ];
    default = [ ];
  };
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.treesitter-languages = treesitter-option;
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.treesitter = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the treesitter layer";
              };
            };
            default = { };
          };
        };
      };
    };
  };
}
