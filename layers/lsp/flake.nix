{
  inputs = {
    nvim-lsp-config = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    rnix-lsp = { url = "github:nix-community/rnix-lsp"; };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ { self, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system: {
        module = { config, lib, pkgs, ... }: {
          config.nvim.layers.lsp.plugins.start = pkgs.flake2vim inputs [ "flake-utils" ];
          config.nvim.layers.lsp.init.lua =
            let
              languages = lib.sort (a: b: a < b) config.nvim.languages;
              if_has_lang = lang: text:
                if (lib.any (x: x == lang) languages) then text else "";
              rnix-lsp = inputs.rnix-lsp.defaultPackage.x86_64-darwin;
              text = lib.concatStrings [
                (if_has_lang "nix" "lsp.rnix.setup{cmd = {'${rnix-lsp}/bin/rnix-lsp'}}\n\n")
                (if_has_lang "python"
                  (''
                    lsp.pyright.setup{
                       cmd = {'${pkgs.nodePackages.pyright}/bin/pyright-langserver', '--stdio'}
                    }
                  '' + "\n\n"))
              ];
            in
            lib.mkIf (text != "") ("local lsp = require('lspconfig')\n\n" + text);
        };
      }
    );
}
    
