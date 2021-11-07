{ lib, pkgs, config, ... }: {
  config.nvim.post = lib.mkIf config.nvim.layers.base.enable {
    lua =
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
      "-- Which-key from base layer\n" + text + "\n-- End of which-key from base layer";
  };
}
