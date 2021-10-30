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
in
{
  options.nvim = lib.mkOption {
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
  config.nvim.init.lua = lib.mkIf config.nvim.layers.base
    ''
      -- General options defined in base layer
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
      -- End of general options defined in base layer
    '';
}
