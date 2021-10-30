{
  inputs = { };
  outputs = { self, ... }: {
    module = { config, lib, pkgs, ... }:
      let
        instances = [ "rnix" "pyright" ];
        lsp-option = lib.mkOption {
          type = lib.types.listOf (lib.types.enum instances);
          description = ''List of LSP instances to setup.'';
          default = [ ];
        };
        enabled = config.nvim.layers.lsp && ((builtins.length config.nvim.lsp-instances) > 0);
      in
      {
        options.nvim = lib.mkOption {
          type = lib.types.submodule {
            options.lsp-instances = lsp-option;
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
              (if_has_instance "pyright"
                (''
                  lsp.pyright.setup{
                     cmd = {'${pkgs.nodePackages.pyright}/bin/pyright-langserver', '--stdio'}
                  }
                '' + "\n\n"))
            ];
          in
          lib.mkIf (enabled && (text != "")) ("local lsp = require('lspconfig')\n\n" + text);
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
      };
  };
}
    
