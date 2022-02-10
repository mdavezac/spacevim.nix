{ config, lib, pkgs, ... }:
let
  enabled = config.nvim.layers.base.enable;
in
{
  imports = [ ./options.nix ./general_options.nix ./which_key.nix ./keys.nix ];
  config.nvim.plugins.start = lib.mkIf enabled
    [
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.which-key-nvim
      pkgs.vimPlugins.telescope-fzy-native-nvim
      pkgs.vimPlugins.nvim-tree-lua
    ];
  config.nvim.init.lua = lib.mkIf enabled ''
    require('telescope').load_extension('fzy_native')
    require('nvim-tree').setup {}
  '';
}
