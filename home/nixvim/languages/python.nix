{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.ruff.enable = true;
    lsp.servers.ruff.rootMarkers = [".git"];
    lsp.servers.pyright.enable = true;
    lsp.servers.pyright.rootMarkers = [".git"];
    lsp.servers.basedpyright.enable = false;
    conform-nvim.enable = true;
    conform-nvim.settings.formatters_by_ft.python = ["ruff_organize_imports" "ruff_format"];
    conform-nvim.settings.formatters.ruff_format.command = lib.getExe pkgs.ruff;
    conform-nvim.settings.formatters.ruff_organize_imports.command = lib.getExe pkgs.ruff;
    neotest = {
      enable = true;
      adapters.python.enable = true;
      adapters.python.settings.runner = "pytest";
    };
  };
}
