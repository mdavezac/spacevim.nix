{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.spacenix.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.spacenix.lsp-instances);
  enabled = config.spacenix.layers.lsp.enable && (with-lsps || with-linters);
  without-trouble = lib.mkIf (!config.spacenix.layers.lsp.trouble);
in
{
  config.spacenix.which-key = lib.mkIf enabled {
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
        key = "<leader>sl";
        command = "<cmd>Telescope lsp_document_symbols<cr>";
        description = "LSP Symbols";
      }
      {
        key = "<localleader>l";
        command = "<cmd>Telescope lsp_document_symbols<cr>";
        description = "LSP Symbols";
      }
      {
        key = "<localleader>w";
        command = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>";
        description = "LSP Symbols";
      }
      (without-trouble {
        key = "<localleader>d";
        command = "<cmd>Telescope diagnostics<cr>";
        description = "LSP diagnostics";
      })
    ];
  };
}
