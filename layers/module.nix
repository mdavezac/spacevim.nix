{ lib, pkgs, config, ... }:
let
  enabled_layers = lib.filterAttrs (k: v: v.enable) config.nvim.layers;

  plugins_opt = lib.mkOption {
    type = lib.types.submodule {
      options.start = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = "Neovim plugins that are automatically started";
      };
    };
    default = { };
  };

  init_opt = lib.mkOption {
    type = lib.types.submodule {
      options.vim = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Vimscript settings for this layer";
      };
      options.lua = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Lua settings for this layer";
      };
    };
    default = { };
  };
  aggregate_init = name: comment: layers:
    builtins.concatStringsSep "\n\n"
      (lib.mapAttrsToList
        (k: v: "${comment} layer ${k}\n${v}")
        (lib.filterAttrs
          (k: v: v != "")
          (builtins.mapAttrs (k: v: (lib.getAttrFromPath (lib.splitString "." name) v)) layers)));
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.plugins = plugins_opt;
      options.init = init_opt;
      options.post = init_opt;
      options.layers = lib.mkOption {
        type = lib.types.submodule { };
        default = { };
      };
    };
  };
}

