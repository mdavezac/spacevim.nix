{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  enabled = config.nvim.layers.lsp.enable && (with-lsps || with-linters);
in
{
  config.nvim.which-key.normal = lib.mkIf enabled {
    "g" = {
      keys.r = {
        command = "<cmd>Telescope lsp_references<cr>";
        description = "Go to reference";
      };
      keys.d = {
        command = "<cmd>Telescope lsp_definitions<cr>";
        description = "Go to definitions";
      };
    };
    "<localleader>d" = {
      name = "+document";
      keys.d = {
        command = "<cmd>Telescope diagnostics bufnr=0<cr>";
        description = "LSP diagnostics";
      };
      keys.s = {
        command = "<cmd>Telescope lsp_document_symbols<cr>";
        description = "Symbols found by LSP";
      };
    };
    "<localleader>w" = {
      name = "+workspace";
      keys.d = {
        command = "<cmd>Telescope diagnostics<cr>";
        description = "LSP diagnostics";
      };
    };
  };
}
