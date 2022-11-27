{ config, lib, pkgs, ... }: {
  imports = [ ./options.nix ./keys.nix ];

  config.nvim.plugins.start = lib.mkIf config.spacenix.layers.tmux.enable [
    pkgs.vimPlugins.vim-tmux-navigator
  ];
  config.nvim.init.vim = lib.mkIf config.spacenix.layers.tmux.enable ''
    let g:tmux_navigator_no_mappings = 1
    let g:tmux_navigator_disable_when_zoomed = 1
  '';
}
