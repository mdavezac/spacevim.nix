{ lib, pkgs, config, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  with-treesitter = config.nvim.layers.treesitter.enable;
  with-norg = config.nvim.layers.neorg.enable;
  enabled = config.nvim.layers.completion.enable;
in
{
  imports = [ ./options.nix ./config.nix ];
}
