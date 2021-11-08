{ config, lib, ... }:
let
  enabled_formatters = lib.filterAttrs (k: v: v.enable) config.nvim.formatters;
  enabled =
    config.nvim.layers.formatter.enable
    && ((builtins.length (builtins.attrNames enabled_formatters)) > 0);
in
{
  config.nvim.which-key = lib.mkIf enabled {
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
  };
}
