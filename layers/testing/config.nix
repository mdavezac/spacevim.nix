{ config, lib, pkgs, ... }:
let
  testing = config.nvim.layers.testing;
in
{
  config.nvim.plugins.start = lib.mkIf testing.enable [
    pkgs.vimPlugins.ultest
    pkgs.vimPlugins.vim-test
  ];

  config.nvim.init.vim = lib.mkIf testing.enable ''
    let test#strategy = "${testing.strategy}"
    let test#python#runner = "${testing.python}"
  '';
}
