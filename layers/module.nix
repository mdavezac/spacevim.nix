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
      options.lua = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Lua settings for this layer";
      };
    };
    default = { };
  };
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.plugins = plugins_opt;
      options.init = init_opt;
      options.layers = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options.enable = lib.mkEnableOption "Whether to use this particular layer";
            options.plugins = plugins_opt;
            options.init = init_opt;
          }
        );
        default = { };
      };
    };
  };

  config.nvim.plugins.start = lib.flatten (
    builtins.attrValues (builtins.mapAttrs (k: x: x.plugins.start) enabled_layers)
  );
  config.nvim.init.lua =
    builtins.concatStringsSep "\n\n"
      (lib.mapAttrsToList
        (k: v: "-- layer ${k}\n${v}")
        (builtins.mapAttrs (k: v: v.init.lua) enabled_layers));
}

