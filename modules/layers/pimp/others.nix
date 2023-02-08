{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.spacenix.layers.pimp;
  enable = cfg.enable;
in {
  config.nvim = lib.mkIf enable {
    plugins.start = [pkgs.vimPlugins.nvim-animate];
    init.lua = ''
      if not vim.g.neovide then
        require('mini.animate').setup()
      end
    '';
    init.vim = ''
      au TermOpen * lua vim.b.minianimate_disable = true
    '';
  };
}
