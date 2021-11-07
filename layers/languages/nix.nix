{ config, lib, pkgs, ... }: {
  config.nvim.treesitter-languages = lib.mkIf config.nvim.languages.nix [ "nix" ];
  config.nvim.lsp-instances = lib.mkIf config.nvim.languages.nix [ "rnix" ];
  config.nvim.formatters.rnix = lib.mkIf config.nvim.languages.nix {
    exe = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
    filetype = "nix";
    enable = true;
  };
}
