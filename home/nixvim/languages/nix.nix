{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.nixd.enable = true;
    conform-nvim.enable = true;
    conform-nvim.settings.formatters_by_ft.nix = ["alejandra"];
    conform-nvim.settings.formatters.alejandra.command = lib.getExe pkgs.alejandra;
  };
}
