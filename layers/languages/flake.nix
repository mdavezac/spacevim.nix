{
  inputs = { };
  outputs = inputs @ { self, ... }: {
    module = { config, lib, pkgs, ... }:
      {
        config.nvim.layers.python.lsp-instances = [ "pyright" ];
        config.nvim.layers.python.treesitter-languages = [ "python" ];
        config.nvim.layers.nix.treesitter-languages = [ "nix" ];
        config.nvim.layers.nix.lsp-instances = [ "rnix" ];
      };
  };
}
