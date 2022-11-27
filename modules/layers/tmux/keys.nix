{ config, lib, ... }: {
  config.spacenix.which-key = lib.mkIf config.spacenix.layers.tmux.enable {
    bindings = [
      {
        key = "<C-h>";
        command = "<cmd>TmuxNavigateLeft<cr>";
        description = "Go to one pane left";
        modes = [ "normal" "visual" "insert" ];
      }
      {
        key = "<C-j>";
        command = "<cmd>TmuxNavigateDown<cr>";
        description = "Go to one pane down";
        modes = [ "normal" "visual" "insert" ];
      }
      {
        key = "<C-k>";
        command = "<cmd>TmuxNavigateUp<cr>";
        description = "Go to one pane up";
        modes = [ "normal" "visual" "insert" ];
      }
      {
        key = "<C-l>";
        command = "<cmd>TmuxNavigateRight<cr>";
        description = "Go to one pane right";
        modes = [ "normal" "visual" "insert" ];
      }
    ];
  };
}
