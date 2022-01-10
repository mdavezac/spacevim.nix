{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  enabled = config.nvim.layers.lsp.enable && (with-lsps && with-linters);
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.linters = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.enable =
            lib.mkEnableOption "Whether to enable the linter";
          options.exe = lib.mkOption {
            type = lib.types.str;
          };
        });
        description = ''Attribute sets of commands for builtins null-ls linters.'';
        default = { };
      };
    };
  };

  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.null-ls-nvim ];
  config.nvim.include-lspconfig = !enabled;
  config.nvim.init.lua =
    let
      null-text = builtins.concatStringsSep "," (
        lib.mapAttrsToList
          (k: v: "nulls.builtins.${k}.with({command=\"${v.exe}\"})")
          (lib.filterAttrs (k: v: v.enable) config.nvim.linters)
      );
    in
    lib.mkIf enabled ''
      local nulls = require("null-ls")
      nulls.setup({
          sources={${null-text}}
      })
    '';
}
