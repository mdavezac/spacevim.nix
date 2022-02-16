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
        { key = "ib"; modes = [ "operator" ]; description = "block body"; }
        { key = "ab"; modes = [ "operator" ]; description = "block"; }
        { key = "."; modes = [ "operator" ]; description = "smart textsubject"; }
        { key = ","; modes = [ "operator" ]; description = "previous textsubject"; }
        { key = "a;"; modes = [ "operator" ]; description = "outer textsubject"; }
        { key = "i;"; modes = [ "operator" ]; description = "inner textsubject"; }
      ];
    };
}
