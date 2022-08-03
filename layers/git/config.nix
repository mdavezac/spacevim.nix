{ config, lib, pkgs, ... }:
let
  enable = config.nvim.layers.git.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enable [
    pkgs.vimPlugins.neogit
    pkgs.vimPlugins.gitsigns-nvim
    pkgs.vimPlugins.vim-diffview
  ];
  config.nvim.init.lua = lib.mkIf enable ''
    require('neogit').setup {
      integrations = { diffview = true },
      auto_refresh = false,
    }
    require('gitsigns').setup {
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
      },
      current_line_blame_formatter_opts = {
        relative_time = true
      },
      keymaps = {
        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
      },
    }
  '';
  config.nvim.post.lua = lib.mkIf (enable && config.nvim.layers.base.enable) ''
    require('which-key').register({
        ["ih"] = [[Select hunk]],
        ["ah"] = [[Select hunk]],
    }, {mode="o", prefix=""})
  '';
}
