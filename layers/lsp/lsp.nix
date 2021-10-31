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
      options.lsp-instances = lib.mkOption {
        type = lib.types.listOf (lib.types.enum [ "rnix" "pyright" ]);
        description = ''List of LSP instances to setup.'';
        default = [ ];
      };
    };
  };

  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.nvim-lspconfig ];
  config.nvim.init.lua =
    let
      instances = lib.sort (a: b: a < b) config.nvim.lsp-instances;
      if_has_instance = instance: text:
        if (lib.any (x: x == instance) instances) then text else "";
      text = lib.concatStrings [
        (if_has_instance "rnix" "lsp.rnix.setup{cmd = {'${pkgs.rnix-lsp}/bin/rnix-lsp'}}\n\n")
      ];
    in
    lib.mkIf (enabled) (
      builtins.concatStringsSep "\n" [
        "local lsp = require('lspconfig')"
        (if_has_instance "rnix" "lsp.rnix.setup{cmd = {'${pkgs.rnix-lsp}/bin/rnix-lsp'}}")
        (if_has_instance "pyright" ''
          lsp.pyright.setup{
             cmd = {'${pkgs.nodePackages.pyright}/bin/pyright-langserver', '--stdio'}
          }
        '')
      ]
    );
}
    
