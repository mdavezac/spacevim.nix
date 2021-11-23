{ config, lib, ... }: {
  config.nvim.which-key = lib.mkIf config.nvim.layers.tmux.enable {
    "" = {
      mode = "normal";
      keys."[\"<C-h>\"]" = {
        command = "<cmd>TmuxNavigateLeft<cr>";
        description = "Go to one pane left";
      };
      keys."[\"<C-j>\"]" = {
        command = "<cmd>TmuxNavigateDown<cr>";
        description = "Go to one pane down";
      };
      keys."[\"<C-k>\"]" = {
        command = "<cmd>TmuxNavigateUp<cr>";
        description = "Go to one pane up";
      };
      keys."[\"<C-l>\"]" = {
        command = "<cmd>TmuxNavigateRight<cr>";
        description = "Go to one pane right";
      };
    };
    "w" = {
      keys.h = {
        command = "<cmd>TmuxNavigateLeft<cr>";
        description = "Go to one pane left";
      };
      keys.j = {
        command = "<cmd>TmuxNavigateDown<cr>";
        description = "Go to one pane down";
      };
      keys.k = {
        command = "<cmd>TmuxNavigateUp<cr>";
        description = "Go to one pane up";
      };
      keys.l = {
        command = "<cmd>TmuxNavigateRight<cr>";
        description = "Go to one pane right";
      };
    };
  };
}
