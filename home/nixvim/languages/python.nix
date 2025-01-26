{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.ruff.enable = true;
    lsp.servers.pyright.enable = true;
    conform-nvim.enable = true;
    conform-nvim.settings.formatters_by_ft.python = ["ruff"];
    conform-nvim.settings.formatters.ruff.command = lib.getExe pkgs.ruff;
  };
}
