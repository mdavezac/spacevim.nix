{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.spacenix.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.spacenix.lsp-instances);
  enabled = config.spacenix.layers.lsp.enable && (with-lsps && with-linters);
in
{
  options.spacenix = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.lsp = lib.mkOption {
            type = lib.types.submodule {
              options.debug-nulls = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable more debug info in null-ls logs";
              };
            };
          };
        };
      };
      options.linters = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.enable =
            lib.mkEnableOption "Whether to enable the linter";
          options.exe = lib.mkOption {
            type = lib.types.str;
          };
          options.extra_args = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Additional arguments for the builtin tool";
          };
          options.timeout = lib.mkOption {
            type = lib.types.int;
            default = 5000;
            description = "Timeout (ms) for the source";
          };
        });
        description = ''Attribute sets of commands for builtins null-ls linters.'';
        default = { };
      };
    };
  };

  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.null-ls-nvim ];
  config.spacenix.include-lspconfig = !enabled;
  config.nvim.init.lua =
    let
      extra_args = args: builtins.concatStringsSep ", " (
        builtins.map (f: "\"${builtins.toString f}\"") args
      );
      null-text = builtins.concatStringsSep ","
        (
          lib.mapAttrsToList
            (k: v: "nulls.builtins.${k}.with({command=\"${v.exe}\", extra_args={${extra_args v.extra_args}}, timeout=${builtins.toString v.timeout}})")
            (lib.filterAttrs (k: v: v.enable) config.spacenix.linters)
        );
      debug = if config.spacenix.layers.lsp.debug-nulls then "true" else "false";
    in
    lib.mkIf enabled ''
      local nulls = require("null-ls")
      nulls.setup({
          debug=${debug},
          sources={${null-text}},
      })
    '';
}
