{ lib, pkgs, config, ... }:
let
  common_options = {
    modes = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [
        "normal"
        "visual"
        "replace"
        "command"
        "insert"
        "operator"
      ]);
      default = [ "normal" ];
      description = "Modes for which this is a binding";
    };
    filetypes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "any" ];
      description = "Filetypes for which this is a binding";
    };
  };
  prefix_mod = lib.types.submodule ({
    options = {
      prefix = lib.mkOption {
        type = lib.types.str;
        description = "Prefix for the binding";
        default = "<leader>";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "Name for a group of keys";
      };
    } // common_options;
  });
  key_mod = lib.types.submodule ({
    options = {
      key = lib.mkOption {
        type = lib.types.str;
        description = "Key associated with the binding";
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "Command called by the key mapping";
        default = "";
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "Description for the key mapping";
        default = "";
      };
      noremap = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to use noremap";
        default = true;
      };
    } // common_options;
  });
  which_key_bindings = mod: lib.mkOption {
    type = lib.types.listOf mod;
    description = "List of key bindings and prefix descriptions";
    default = [ ];
  };
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.base = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the base layer";
              };
            };
            default = { };
          };
        };
      };
      options.which-key = lib.mkOption {
        type = lib.types.submodule {
          options.bindings = which_key_bindings key_mod;
          options.groups = which_key_bindings prefix_mod;
          options.leader = lib.mkOption {
            type = lib.types.str;
            default = " ";
            description = "The leader key is the main entry-point into the which-key menu";
          };
          options.localleader = lib.mkOption {
            type = lib.types.str;
            default = ",";
            description = "The `local` leader key is a main entry point for filetype specific actions";
          };
        };
        default = { };
      };
      options.case = lib.mkOption {
        type = lib.types.enum [ "nomatch" "match" "smart" ];
        default = "smart";
        description = ''
          One of
           - nomatch: ignores case
           - match: does not ignore case
           - smart: ignores case unless a search pattern contains capital letters
        '';
      };
      options.highlight-search = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''Whether to highlight the current search term'';
      };
      options.incsearch = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''Whether to start matching while the search pattern is being written'';
      };
      options.expandtab = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''No tabs, just spaces'';
      };
      options.line-numbers = lib.mkOption {
        type = lib.types.enum [ "on" "off" "relative" ];
        default = "relative";
        description = ''Whether and how to display line numbers'';
      };
      options.textwidth = lib.mkOption {
        type = lib.types.ints.between 0 1000;
        default = 88;
        description = ''Maximum line length before a break is introduced'';
      };
      options.tabwidth = lib.mkOption {
        type = lib.types.ints.between 0 1000;
        default = 4;
        description = ''Tab width'';
      };
    };
  };
}
