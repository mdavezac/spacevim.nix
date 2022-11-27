{ config, lib, pkgs, ... }:
let
  enabled =
    config.spacenix.layers.base.enable
    && config.spacenix.layers.treesitter.enable
    && ((builtins.length config.spacenix.treesitter-languages) > 0);
in
{
  config.spacenix.which-key =
    lib.mkIf enabled {
      bindings = builtins.map (k: k // { filetypes = config.spacenix.treesitter-languages; }) [
        {
          key = "<leader>st";
          command = "<cmd>Telescope treesitter<cr>";
          description = "Treesitter";
        }
        {
          key = "<localleader>T";
          command = "<cmd>Telescope treesitter<cr>";
          description = "Treesitter";
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
