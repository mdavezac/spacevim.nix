{ config, pkgs, lib, ... }:
let
  with-internal-lsp = builtins.any
    (v: v.enable && (v.setup_location == "lsp"))
    (builtins.attrValues config.nvim.lsp-instances);
  internal-lsp = lib.filterAttrs
    (k: v: v.enable && (v.setup_location == "internal"))
    config.nvim.lsp-instances;
  enabled = config.nvim.layers.lsp.enable && config.nvim.layers.lsp.signature && with-internal-lsp;
in
{
  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.lsp_signature-nvim ];
  config.nvim.post.lua = lib.mkIf enabled ''
    require'lsp_signature'.setup({zindex=50})
  '';
}
