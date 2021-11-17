{ config, pkgs, lib, ... }:
let
  with-internal-lsp = builtins.any
    (v: v.enable && (v.setup_location == "lsp"))
    (builtins.attrValues config.nvim.lsp-instances);
  internal-lsp = lib.filterAttrs
    (k: v: v.enable && (v.setup_location == "internal"))
    config.nvim.lsp-instances;
  enabled = config.nvim.layers.lsp.enable && config.nvim.layers.lsp.saga && with-internal-lsp;
in
{
  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.lspsaga-nvim ];
  config.nvim.post.lua = lib.mkIf enabled ''
    require('lspsaga').init_lsp_saga({code_action_prompt={enable=false}})
  '';
  config.nvim.which-key = lib.mkIf enabled {
    "," = {
      mode = "normal";
      keys.r = {
        command = "<cmd>lua require'lspsaga.provider'.lsp_finder()<cr>";
        description = "Show references and definition";
      };
      keys.s = {
        command = "<cmd>lua require('lspsaga.signaturehelp').signature_help()<cr>";
        description = "Show signature";
      };
      keys.h = {
        command = "<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>";
        description = "Show doc";
      };
      keys.e = {
        command = "<cmd>lua require('lspsaga.rename').rename()<cr>";
        description = "Rename";
      };
      keys.p = {
        command = "<cmd>lua require'lspsaga.provider'.preview_definition()<cr>";
        description = "Preview definition";
      };
    };
    "g" = {
      mode = "normal";
      keys.T = {
        command = "<cmd>lua require('lspsaga.floaterm').open_float_terminal('${pkgs.gitui}/bin/gitui')<cr>";
        description = "gitui";
      };
    };
  };
}
