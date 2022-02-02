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
    bindings = [
      {
        key = "<localleader>r";
        command = "<cmd>lua require'lspsaga.provider'.lsp_finder()<cr>";
        description = "References and definition";
      }
      {
        key = "<localleader>s";
        command = "<cmd>lua require('lspsaga.signaturehelp').signature_help()<cr>";
        description = "Signature";
      }
      {
        key = "<localleader>h";
        command = "<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>";
        description = "Doc";
      }
      {
        key = "<localleader>e";
        command = "<cmd>lua require('lspsaga.rename').rename()<cr>";
        description = "Rename";
      }
      {
        key = "<localleader>p";
        command = "<cmd>lua require'lspsaga.provider'.preview_definition()<cr>";
        description = "Preview definition";
      }
      {
        key = "<localleader><localleader>";
        command = "<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<cr>";
        description = "Show diagnostic";
      }
      {
        key = "gT";
        command = "<cmd>lua require('lspsaga.floaterm').open_float_terminal('${pkgs.gitui}/bin/gitui')<cr>";
        description = "gitui";
      }
      {
        key = "]e";
        command = "<cmd>Lspsaga diagnostic_jump_next<CR>";
        description = "Diagnostic";
      }
      {
        key = "[e";
        command = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
        description = "Diagnostic";
      }
    ];
  };
}
