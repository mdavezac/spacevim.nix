{ lib, pkgs, config, tools, ... }:
let
  which_key_mod = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options.command = lib.mkOption {
        type = lib.types.str;
        description = "Command called by the key mapping";
      };
      options.description = lib.mkOption {
        type = lib.types.str;
        description = "Description for the key mapping";
        default = "";
      };
    });
    default = { };
  };
  which_group_mod = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options.name = lib.mkOption {
        type = lib.types.str;
        description = "Name for a group of keys";
        default = "";
      };
      options.keys = which_key_mod;
      options.mode = lib.mkOption {
        type = lib.types.enum [ "normal" "visual" "replace" "command" "insert" ];
        description = "Mode for which the key is valid";
        default = "normal";
      };
    });
    default = { };
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
      options.which-key = which_group_mod;
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
