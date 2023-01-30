{ config, lib, pkgs, ... }:
let
  cfg = config.spacenix.layers.pimp;
  enable = cfg.enable;
in
{
  config.nvim = lib.mkIf enable {
    plugins.start = [ pkgs.vimPlugins.nvim-animate ];
    init.lua = ''
      require('mini.animate').setup()
    '';

  };
}
