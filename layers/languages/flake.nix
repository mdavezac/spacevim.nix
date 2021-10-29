{
  inputs = { };
  outputs = { self, ... }: {
    module = { config, lib, pkgs, ... }:
      {
        config.nvim.layers.python.treesitter-languages = [ "python" ];
        config.nvim.layers.python.lsp-instances = [ "pyright" ];
        config.nvim.layers.python.formatters.black = {
          exe = "${pkgs.black}/bin/black";
          args = [ "-q" "-" ];
          filetype = "python";
          enable = true;
        };
        config.nvim.layers.nix.treesitter-languages = [ "nix" ];
        config.nvim.layers.nix.lsp-instances = [ "rnix" ];
        config.nvim.layers.nix.formatters.rnix = {
          exe = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          filetype = "nix";
          enable = true;
        };
      };
  };
}
