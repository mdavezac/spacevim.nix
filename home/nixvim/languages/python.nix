{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.ruff.enable = true;
    lsp.servers.pyright.enable = true;
    conform-nvim.enable = true;
    conform-nvim.settings.formatters_by_ft.python = ["ruff_format"];
    conform-nvim.settings.formatters.ruff.command = lib.getExe pkgs.ruff;
    neotest = {
      enable = true;
      adapters.python.enable = true;
      adapters.python.settings.runner = "pytest";
    };
  };
}
