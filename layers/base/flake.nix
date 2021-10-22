{
  inputs = {
    which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    plenary = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    telescope = { url = "github:/nvim-telescope/telescope.nvim"; flake = false; };
  };
  outputs = inputs @ { self, ... }:
    let
      vim-plugin-from-key-value-pair = nixpkgs: k: v: nixpkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = k;
        version = "master";
        src = v;
      };
      plugins = nixpkgs: builtins.attrValues (
        builtins.mapAttrs
          (vim-plugin-from-key-value-pair nixpkgs)
          (builtins.removeAttrs inputs [ "self" "nixpkgs" ])
      );
    in
    rec {
      overlay = final: prev: {
        layers.base.plugins.start = plugins final;
      };
      module = { config, lib, pkgs, ... }: {
        options.nvim = lib.mkOption {
          type = lib.types.submodule {
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
        config.nvim.init.lua =
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
        config.nvim.layers.base.enable = true;
        config.nvim.layers.base.plugins.start = pkgs.layers.base.plugins.start;
        config.nvim.layers.base.init.lua = builtins.readFile ./init.lua;
      };
    };
}
    