{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.terraformls = {
      enable = true;
      package = pkgs.tofu-ls;
      cmd = ["opentofu-ls" "serve"];
    };
    conform-nvim = {
      enable = true;
      settings.formatters_by_ft.terraform = ["tfmt"];
      settings.formatters.tfmt.command = lib.getExe pkgs.opentofu;
      settings.formatters.tfmt.args = ["fmt" "-"];
      settings.formatters.tfmt.stdin = true;
    };
  };
}
