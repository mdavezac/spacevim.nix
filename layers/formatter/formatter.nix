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
  formatters-options = lib.mkOption {
    type = lib.types.attrsOf formatter-option;
    description = ''Dictionary of formatter configurations.'';
    default = { };
  };
  enabled =
    config.nvim.layers.formatter.enable && (
      builtins.any (builtins.attrValues (lib.mapAttrs (k: v: v.enable) config.nvim.formatters))
    );
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.format-on-save = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to format buffer when saving";
        default = true;
      };
      options.formatters = formatters-options;
      options.layers = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.formatters = formatters-options;
        });
      };
    };
  };

  config.nvim.formatters =
    let
      enabled_layers = lib.filterAttrs
        (k: v: v.enable && (builtins.hasAttr "formatters" v))
        config.nvim.layers;
      known_formatters = builtins.mapAttrs (k: v: v.formatters) enabled_layers;
      formatter_set = builtins.foldl' (a: b: a // b) { } (builtins.attrValues known_formatters);
    in
    formatter_set;
  config.nvim.layers.formatter.plugins.start = [ pkgs.vimPlugins.formatter-nvim ];
  config.nvim.layers.formatter.init.lua =
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
      enabled_formatters = lib.filterAttrs (k: v: v.enable) config.nvim.formatters;
      enable = (builtins.length (builtins.attrNames enabled_formatters)) > 0;
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
    lib.mkIf enable (lib.concatStrings [
      "require(\"formatter\").setup({\n  filetype={\n"
      (builtins.concatStringsSep ",\n" (builtins.map buildFiletype filetypes))
      "\n  }\n})"
    ]);
}
