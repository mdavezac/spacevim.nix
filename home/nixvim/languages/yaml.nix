{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    conform-nvim.enable = true;
    conform-nvim.settings.formatters_by_ft.yaml = ["yamlfmt"];
    conform-nvim.settings.formatters.yamlfmt.command = lib.getExe pkgs.yamlfmt;
  };
}
