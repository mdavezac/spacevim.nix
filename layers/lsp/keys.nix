{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  enabled = config.nvim.layers.lsp.enable && (with-lsps || with-linters);
in
{
  config.nvim.which-key = lib.mkIf enabled {
    groups = [
      { prefix = "<localleader>w"; name = "+Buffer"; }
      { prefix = "<localleader>d"; name = "+Workspace"; }
    ];
    bindings = [
      {
        key = "gr";
        command = "<cmd>Telescope lsp_references<cr>";
        description = "Reference";
      }
      {
        key = "gd";
        command = "<cmd>Telescope lsp_definitions<cr>";
        description = "Definitions";
      }
      {
        key = "<localleader>dd";
        command = "<cmd>Telescope diagnostics bufnr=0<cr>";
        description = "LSP diagnostics";
      }
      {
        key = "<localleader>ds";
        command = "<cmd>Telescope lsp_document_symbols<cr>";
        description = "LSP Symbols";
      }
      {
        key = "<localleader>dd";
        command = "<cmd>Telescope diagnostics<cr>";
        description = "LSP diagnostics";
      }
    ];
  };
}
