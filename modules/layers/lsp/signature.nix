{ config, pkgs, lib, ... }:
let
  with-internal-lsp = builtins.any
    (v: v.enable && (v.setup_location == "lsp"))
    (builtins.attrValues config.spacenix.lsp-instances);
  internal-lsp = lib.filterAttrs
    (k: v: v.enable && (v.setup_location == "internal"))
    config.spacenix.lsp-instances;
  enabled = config.spacenix.layers.lsp.enable && config.spacenix.layers.lsp.signature && with-internal-lsp;
in
{
  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.lsp_signature-nvim ];
  config.nvim.post.lua = lib.mkIf enabled ''
    require'lsp_signature'.setup({
        zindex=50, hint_enable=false, timer_interval=1, auto_close_after=10
    })
  '';
}
