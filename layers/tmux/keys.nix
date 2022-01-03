{ config, lib, ... }: {
  config.nvim.which-key =
    let
      switch_pane = {
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
    in
    lib.mkIf config.nvim.layers.tmux.enable {
      normal = {
        "" = switch_pane;
        "w" = switch_pane;
      };
      visual = {
        "" = switch_pane;
      };
      insert = {
        "" = switch_pane;
      };
    };
}
