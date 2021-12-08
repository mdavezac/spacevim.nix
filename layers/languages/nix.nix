{ config, lib, pkgs, ... }: {
  config.nvim.lsp-instances.rnix.cmd = [ "${pkgs.rnix-lsp}/bin/rnix-lsp" ];
  config.nvim.treesitter-languages = lib.mkIf config.nvim.languages.nix [ "nix" ];
  config.nvim.formatters.rnix = lib.mkIf config.nvim.languages.nix (
    lib.mkDefault {
      exe = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
      filetype = "nix";
      enable = true;
    }
  );
  config.nvim.format-on-save = [ "*.nix" ];
}
