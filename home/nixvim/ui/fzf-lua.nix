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
    };
  };
}
