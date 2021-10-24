{ lib, pkgs, config, ... }:
let
  case = builtins.getAttr config.nvim.case {
    smart = { ignore = "true"; smart = "true"; };
    match = { ignore = "false"; smart = "false"; };
    nomatch = { ignore = "true"; smart = "false"; };
  };
  linenumbers = builtins.getAttr config.nvim.line-numbers {
    on = { number = "true"; relative = "false"; };
    off = { number = "false"; relative = "false"; };
    relative = { number = "true"; relative = "true"; };
  };
  general_options =
    ''
      -- General options
      vim.g.mapleader = "${config.nvim.leader}"
      vim.g.maplocalleader = "${config.nvim.localleader}"
      vim.o.ignorecase = ${case.ignore}
      vim.o.smartcase = ${case.smart}
      vim.o.hlsearch = ${if config.nvim.highlight-search then "true" else "false"}
      vim.o.incsearch = ${if config.nvim.incsearch then "true" else "false"}
      vim.bo.expandtab = ${if config.nvim.expandtab then "true" else "false"}
      vim.wo.number = ${linenumbers.number}
      vim.wo.relativenumber = ${linenumbers.relative}
      vim.bo.textwidth = ${builtins.toString config.nvim.textwidth}
    '';
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
  enabled-which-key-layers = layers:
    lib.filterAttrs (k: v: v.enable && (lib.hasAttr "which-key" v)) layers;
  layer-mappings = layers:
    builtins.mapAttrs (k: v: v.which-key) (enabled-which-key-layers layers);
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.which-key = which_group_mod;
      options.layers = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options.which-key = which_group_mod;
          }
        );
      };
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
    };
  };
  config.nvim.which-key =
    builtins.foldl' (a: b: a // b) { } (
      builtins.attrValues (layer-mappings config.nvim.layers)
    );
  config.nvim.layers.base.init.lua =
    let
      single_mapping = k: v:
        if v.description == ""
        then "${k} = {\"${v.command}\"}"
        else "${k} = {\"${v.command}\", \"${v.description}\"}";
      mappings = m:
        builtins.concatStringsSep
          ",\n    "
          (builtins.attrValues (lib.mapAttrs single_mapping m.keys));
      get_mode = n: builtins.getAttr n {
        normal = "n";
        replace = "r";
        command = "c";
        insert = "i";
        visual = "v";
      };
      grouping = k: v:
        ''wk.register({
                    ["${k}"] = {
                      name="${v.name}",
                      ''
        + "    " + (mappings v)
        + ''
              }
          }, {mode = "${get_mode v.mode}"})'';
    in
    (builtins.readFile ./init.lua)
    + "\n\n" + general_options
    + builtins.concatStringsSep "\n" (
      builtins.attrValues (
        lib.mapAttrs grouping config.nvim.which-key
      )
    );
}
