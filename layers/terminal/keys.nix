{ config, lib, pkgs, ... }:
let
  enable = config.nvim.layers.terminal.enable;
in
{
  config.nvim.which-key.normal = lib.mkIf enable {
    "<leader>" = {
      keys."[\";\"]" = {
        command = "<cmd>lua term_toggle()<cr>";
        description = "Toggle terminal and focus";
      };
    };
    "<leader>t" = {
      keys.t = {
        command = "<cmd>lua require'nterm.main'.term_toggle()<cr>";
        description = "Toggle terminal without focussing";
      };
    };
  };
}
