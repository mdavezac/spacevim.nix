{ config, lib, pkgs, ... }:
let
  enabled_formatters = lib.filterAttrs (k: v: v.enable) config.nvim.formatters;
  enabled =
    config.nvim.layers.formatter.enable
    && ((builtins.length (builtins.attrNames enabled_formatters)) > 0);
in
{
  config.nvim.plugins = lib.mkIf enabled { start = [ pkgs.vimPlugins.formatter-nvim ]; };
  config.nvim.init =
    let
      buildFormatter = { exe, args ? [ ], stdin ? true, ... }:
        ''
          function()
            return {
              exe = '${exe}',
              args = { ${builtins.concatStringsSep ", " (builtins.map (x: "\"${x}\"") args)} },
              stdin = ${if stdin then "true" else "false"},
            }
          end
        '';
      filetypes = builtins.attrValues (builtins.mapAttrs (k: v: v.filetype) enabled_formatters);
      buildFiletype = filetype:
        let
          ft_formatters = lib.filterAttrs (k: v: v.filetype == filetype) enabled_formatters;
        in
        (
          "   ${filetype} = {\n"
          +
          builtins.concatStringsSep ",\n" (
            builtins.map buildFormatter (builtins.attrValues ft_formatters)
          )
          + "    }\n"
        );
    in
    lib.mkIf enabled {
      lua = (lib.concatStrings [
        "-- Formatter layer\n"
        "require(\"formatter\").setup({\n  filetype={\n"
        (builtins.concatStringsSep ",\n" (builtins.map buildFiletype filetypes))
        "\n  }\n})"
        "-- End of formatter layer\n"
      ]);
    };
}
