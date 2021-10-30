{ config, lib, pkgs, ... }:
let
  formatter-option = lib.types.submodule ({
    options.enable = lib.mkEnableOption "Whether to run this specific formatter";
    options.filetype = lib.mkOption {
      type = lib.types.str;
      description = "Filetype for which to run this formatter";
    };
    options.exe = lib.mkOption {
      type = lib.types.str;
      description = "Binary to call for formatting";
    };
    options.args = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of command-line arguments for the formatter";
      default = [ ];
    };
    options.stdin = lib.mkOption {
      type = lib.types.bool;
      description = "Whether the formatter can use stdin";
      default = true;
    };
  });
  enabled_formatters = lib.filterAttrs (k: v: v.enable) config.nvim.formatters;
  enabled = config.nvim.layers.formatter
    && ((builtins.length (builtins.attrNames enabled_formatters)) > 0);
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.formatters = lib.mkOption {
        type = lib.types.attrsOf formatter-option;
        description = ''Dictionary of formatter configurations.'';
        default = { };
      };
    };
  };

  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.formatter-nvim ];
  config.nvim.init.lua =
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
    lib.mkIf enabled (lib.concatStrings [
      "-- Formatter layer\n"
      "require(\"formatter\").setup({\n  filetype={\n"
      (builtins.concatStringsSep ",\n" (builtins.map buildFiletype filetypes))
      "\n  }\n})"
      "-- End of formatter layer\n"
    ]);
}
