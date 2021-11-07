{ config, lib, pkgs, ... }:
let
  linters-enabled = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  enabled = config.nvim.layers.lsp.enable && (
    ((builtins.length config.nvim.lsp-instances) > 0) || linters-enabled
  );
in
{
  config.nvim.which-key = lib.mkIf enabled {
    "<localleader>d" = {
      name = "+document";
      mode = "normal";
      keys.d = {
        command = "<cmd>Telescope lsp_document_diagnostics<cr>";
        description = "LSP diagnostics";
      };
      keys.s = {
        command = "<cmd>Telescope lsp_document_symbols<cr>";
        description = "Symbols found by LSP";
      };
    };
    "<localleader>w" = {
      name = "+workspace";
      mode = "normal";
      keys.d = {
        command = "<cmd>Telescope lsp_workspace_diagnostics<cr>";
        description = "LSP diagnostics";
      };
      keys.s = {
        command = "<cmd>Telescope lsp_workspace_symbols<cr>";
        description = "Symbols found by LSP";
      };
    };
    "<localleader>" = {
      mode = "normal";
      keys."[\",\"]" = {
        command = "<cmd>Telescope lsp_code_actions<cr>";
        description = "LSP code-actions";
      };
    };
  };
}
