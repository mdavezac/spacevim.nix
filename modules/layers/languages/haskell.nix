{
  config,
  lib,
  pkgs,
  ...
}: let
  enableIf = lib.mkIf config.spacenix.languages.haskell;
in {
  config.spacenix.lsp-instances.hls = enableIf {
    cmd = "\"${pkgs.haskell-language-server}/bin/haskell-language-server\", \"--lsp\"";
  };
  config.spacenix.treesitter-languages = enableIf ["haskell"];
  config.nvim.init = enableIf {
    lua = ''
      require('lspconfig')['hls'].setup{
        filetypes = { 'haskell', 'lhaskell', 'cabal' },
      }
    '';
  };
}
