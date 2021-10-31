{ config, lib, pkgs, ... }:
let
  linters-enabled = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  enabled = config.nvim.layers.lsp && (
    ((builtins.length config.nvim.lsp-instances) > 0) || linters-enabled
  );
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
      nulls.config({
          sources={${null-text}}
      })
    '';
  config.nvim.post.lua = lib.mkIf enabled ''
    require("lspconfig")["null-ls"].setup({})
  '';
}
    
