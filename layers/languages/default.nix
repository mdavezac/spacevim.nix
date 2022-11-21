{ config, lib, pkgs, ... }: {
  imports = [ ./options.nix ./nix.nix ./python.nix ./markdown.nix ./rust.nix ];
  config.nvim.plugins.start = [ pkgs.vimPlugins.vim-commentary ];
}
