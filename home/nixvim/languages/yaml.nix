{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.yamlls = {
      enable = true;
      package = pkgs.yaml-language-server;
      settings.yaml = {
        format.enable = true;
        keyOrdering = false;
      };
    };

    schemastore.enable = true;
    schemastore.yaml.enable = true;

    conform-nvim.enable = true;
    conform-nvim.settings.formatters_by_ft.yaml = ["yamlfmt"];
    conform-nvim.settings.formatters.yamlfmt.command = lib.getExe pkgs.yamlfmt;
  };
}
