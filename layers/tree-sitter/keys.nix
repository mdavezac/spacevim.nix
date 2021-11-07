{ config, lib, pkgs, ... }:
let
  enabled =
    config.nvim.layers.treesitter.enable
    && ((builtins.length config.nvim.treesitter-languages) > 0);
in
{
  config.nvim.which-key = lib.mkIf enabled {
    "<leader>s" = {
      keys.o = {
        command = "<cmd>Telescope treesitter<cr>";
        description = "Search syntax nodes of current buffer";
      };
    };
  };
}
