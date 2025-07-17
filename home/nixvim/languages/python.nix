{
  pkgs,
  lib,
  ...
}: {
  # programs.nixvim.extraConfigLuaPre = ''
  #   vim.lsp.config('pyrefly', {
  #       cmd = { '${pkgs.pyrefly}/bin/pyrefly', 'lsp' },
  #   })
  # '';
  programs.nixvim.plugins = {
    lsp.servers.ruff.enable = true;
    lsp.servers.pyright.enable = true;
    # lsp.servers.pyright.cmd = ["${pkgs.pyrefly}/bin/pyrefly" "lsp"];
    # lsp.servers.pyright.name = "pyrefly";
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
