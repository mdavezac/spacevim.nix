{ lib, pkgs, config, ... }:
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
  enabled-which-key-layers = layers:
    lib.filterAttrs (k: v: v.enable && (lib.hasAttr "which-key" v)) layers;
  layer-mappings = layers:
    builtins.mapAttrs (k: v: v.which-key) (enabled-which-key-layers layers);
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.which-key = which_group_mod;
    };
  };
  config.nvim.init.lua =
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
      text = (builtins.readFile ./init.lua)
        + builtins.concatStringsSep "\n" (
        builtins.attrValues (
          lib.mapAttrs grouping config.nvim.which-key
        )
      );
    in
    lib.mkIf config.nvim.layers.base (
      "-- Which-key from base layer\n" + text + "\n-- End of which-key from base layer"
    );
}
