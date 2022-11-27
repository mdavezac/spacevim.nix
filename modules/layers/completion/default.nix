{ lib, pkgs, config, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.spacenix.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.spacenix.lsp-instances);
  with-treesitter = config.spacenix.layers.treesitter.enable;
  with-norg = config.spacenix.layers.neorg.enable;
  enabled = config.spacenix.layers.completion.enable;
in
{
  imports = [ ./options.nix ./config.nix ];
}
