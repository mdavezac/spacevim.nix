{ config, lib, pkgs, ... }: {
  config.nvim.lsp-instances.rnix.cmd = [ "${pkgs.rnix-lsp}/bin/rnix-lsp" ];
  config.nvim.treesitter-languages = lib.mkIf config.nvim.languages.nix [ "nix" ];
  config.nvim.formatters.nixpkgs-fmt = lib.mkIf config.nvim.languages.nix {
    exe = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
    filetype = "nix";
    enable = true;
  };
  config.nvim.format-on-save = [ "*.nix" ];
  config.nvim.layers.completion.sources = lib.mkIf config.nvim.languages.nix {
    nix = [
      {
        name = "treesitter";
        priority = 2;
        group_index = 2;
      }
      {
        name = "nvim_lsp";
        priority = 2;
        group_index = 2;
      }
    ];
  };
}
