{ config, lib, pkgs, ... }:
let
  is_colorscheme = color:
    (!(builtins.isNull config.nvim.colorscheme))
    && config.nvim.colorscheme == color;
  isnt_colorscheme = color:
    (!(builtins.isNull config.nvim.colorscheme))
    && config.nvim.colorscheme != color;
  enabled = config.nvim.layers.pimp.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enabled [
    pkgs.vimPlugins.monochrome
    pkgs.vimPlugins.rainglow
    pkgs.vimPlugins.neon
    pkgs.vimPlugins.lush
    pkgs.vimPlugins.zenbones
    pkgs.vimPlugins.catpuccino
    pkgs.vimPlugins.awesome-vim-colorschemes
    pkgs.vimPlugins.nvim-web-devicons
  ];
  config.nvim.init.vim = lib.mkIf enabled ''
    set background=${config.nvim.background}
  '';
  config.nvim.init.lua = lib.mkIf enabled (
    builtins.concatStringsSep "\n" [
      ''
        -- Pimp layer
        require'nvim-web-devicons'.setup {
         default = true;
        }
        -- End of pimp layer
      ''
      (
        if (is_colorscheme "catppuccino")
        then (builtins.readFile ./catpuccino.lua) else ""
      )
    ]
  );
  config.nvim.post.vim = lib.mkIf enabled (
    builtins.concatStringsSep "\n" [
      ''" Pimp layer
        set termguicolors
      ''
      (
        if (is_colorscheme "neon")
        then ''
          let g:neon_style = "${config.nvim.background}"
          let g:neon_italic_keyword = 1
          let g:neon_italic_function = 1
          let g:neon_transparent = 0
        ''
        else ""
      )
      (
        if (builtins.isNull config.nvim.colorscheme) then ""
        else "colorscheme ${config.nvim.colorscheme}"
      )
      (
        if (is_colorscheme "neon") then ''
          highlight HopNextKey gui=bold,underline guifg=red
          highlight HopNextKey1 gui=bold,underline guifg=blue
          highlight HopNextKey2 gui=bold,underline guifg=green
          highlight HopUnmatched guifg=#335566
        '' else ""
      )
      ''" End of pimp layer''
    ]
  );
}
