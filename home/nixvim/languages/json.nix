{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    schemastore.enable = true;
    schemastore.json.enable = true;
    # Language Server
    lsp.servers.jsonls = {
      enable = true;
      # Provides the vscode-json-language-server binary
      package = pkgs.vscode-langservers-extracted;
      settings = {
        json = {
          validate.enable = true;
          # Keep empty list to let upstream defaults (or user overrides) supply schemas
          schemas = [];
        };
      };
    };

    # Formatting
    conform-nvim.enable = true;
    conform-nvim.settings = {
      formatters_by_ft = {
        json = ["prettierd" "jq"];
        jsonc = ["prettierd" "jq"];
      };
      formatters.prettierd.command = lib.getExe pkgs.prettierd;
      formatters.jq.command = lib.getExe pkgs.jq;
    };
  };
}
