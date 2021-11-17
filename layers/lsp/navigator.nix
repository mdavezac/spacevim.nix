{ config, pkgs, lib, ... }:
let
  with-navigator-lsp = builtins.any
    (v: v.enable && (v.setup_location == "navigator"))
    (builtins.attrValues config.nvim.lsp-instances);
  navigator-lsp = lib.filterAttrs
    (k: v: v.enable && (v.setup_location == "navigator"))
    config.nvim.lsp-instances;
  enabled = config.nvim.layers.lsp.enable && with-navigator-lsp;
in
{
  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.guihua pkgs.vimPlugins.lsp-navigator ];
  config.nvim.post.lua = lib.mkIf enabled ''
    require('navigator').setup()
  '';
  config.nvim.post.vim = lib.mkIf enabled ''
    autocmd FileType guihua lua require('cmp').setup.buffer { enabled = false }
    autocmd FileType guihua_rust lua require('cmp').setup.buffer { enabled = false }
  '';
  #  config.nvim.which-key = lib.mkIf enabled {
  #    "g" = {
  #      mode = "normal";
  #      keys.r = {
  #        command = "<cmd>lua require('navigator.reference').reference()<cr>";
  #        description = "Go to reference";
  #      };
  #    };
  #    ",g" = {
  #      mode = "normal";
  #      keys.r = {
  #        command = "<cmd>declaration({ border = 'rounded', max_width = 80 })<cr>";
  #        description = "Go to reference";
  #      };
  #      keys.s = {
  #        command = "<cmd>lua signature_help()<cr>";
  #        description = "Show signature";
  #      };
  #      keys.p = {
  #        command = "<cmd>lua require('navigator.definition').definition_preview()<cr>";
  #        description = "Show definition";
  #      };
  #      keys.w = {
  #        command = "<cmd>lua require('navigator.symbols').document_symbols()<cr>";
  #        description = "Show symbols";
  #      };
  #    };
  #  };
}
