{
  programs.nixvim.plugins.fzf-lua = {
    enable = true;
    keymaps = {
      "<leader><space>" = {
        action = "files";
        options = {
          desc = "Find project file";
        };
      };
      "<leader>," = {
        action = "buffers";
        options = {
          desc = "Find buffer";
        };
      };
      "<leader>/" = {
        action = "live_grep";
        options = {
          desc = "Search project for text";
        };
      };
      "<leader>b/" = {
        action = "lgrep_curbuf";
        options = {
          desc = "Search buffer for text";
        };
      };
      "<leader>c/" = {
        action = "lsp_workspace_symbols";
        options = {
          desc = "Search workspace for symbol";
        };
      };
      "<leader>cD" = {
        action = "lsp_workspace_diagnostics";
        options = {
          desc = "Search workspace for diagnostic";
        };
      };
    };
  };
}
