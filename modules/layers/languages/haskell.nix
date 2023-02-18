{
  config,
  lib,
  pkgs,
  ...
}: let
  enableIf = lib.mkIf config.spacenix.languages.haskell;
in {
  config.nvim.plugins.start = enableIf [pkgs.vimPlugins.haskell-tools-nvim];
  config.spacenix.treesitter-languages = enableIf ["haskell"];
}
