{ config, lib, pkgs, ... }:
let
  enable = config.nvim.layers.git.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enable [
    pkgs.vimPlugins.neogit
    pkgs.vimPlugins.gitsigns-nvim
  ];
  config.nvim.init.lua = lib.mkIf enable ''
    require('neogit').setup {}
    require('gitsigns').setup {
      keymaps = {
        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
      }
    }
  '';
  config.nvim.post.lua = lib.mkIf (enable && config.nvim.layers.base.enable) ''
    require('which-key').register({
        ["ih"] = [[Select hunk]],
        ["ah"] = [[Select hunk]],
    }, {mode="o", prefix=""})
  '';
}
