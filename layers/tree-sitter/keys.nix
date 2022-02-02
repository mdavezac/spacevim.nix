{ config, lib, pkgs, ... }:
let
  enabled =
    config.nvim.layers.base.enable
    && config.nvim.layers.treesitter.enable
    && ((builtins.length config.nvim.treesitter-languages) > 0);
in
{
  config.nvim.which-key =
    lib.mkIf enabled {
      bindings = builtins.map (k: k // { filetypes = config.nvim.treesitter-languages; }) [
        {
          key = "<leader>so";
          command = "<cmd>Telescope treesitter<cr>";
          description = "Search syntax nodes of current buffer";
        }
        { key = "if"; modes = [ "operator" ]; description = "function body"; }
        { key = "af"; modes = [ "operator" ]; description = "function"; }
        { key = "ic"; modes = [ "operator" ]; description = "class body"; }
        { key = "ac"; modes = [ "operator" ]; description = "class"; }
      ];
    };
}
