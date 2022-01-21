{ lib, ... }:
let
  terminal-layer-options = suboptions: lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.terminal = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to enable the terminal layer";
                };
              } // suboptions;
            };
            default = { };
          };
        };
      };
    };
  };
in
{
  options.nvim = terminal-layer-options {
    repl = lib.mkOption {
      type = lib.types.submodule {
        options.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to integrate with a REPL";
        };
        options.repl-open-cmd = lib.mkOption {
          type = lib.types.str;
          default = "require('iron.view').openwin('rightbelow vertical split')";
          description = "Command to run when opening REPL window";
        };
        options.favored = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          description = "For each filetype, the REPL to use.";
        };
      };
      default = { };
    };
  };
}
