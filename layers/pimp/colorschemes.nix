{ config, lib, pkgs, ... }:
let
  is_colorscheme = color:
    (!(builtins.isNull config.nvim.colorscheme))
    && config.nvim.colorscheme == color;
  isnt_colorscheme = color:
    (!(builtins.isNull config.nvim.colorscheme))
    && config.nvim.colorscheme != color;
in

{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.colorscheme = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''Colorschemes'';
      };
    };
  };
  config.nvim.plugins.start = lib.mkIf config.nvim.layers.pimp [
    pkgs.vimPlugins.rainglow
    pkgs.vimPlugins.neon
    pkgs.vimPlugins.catpuccino
    pkgs.vimPlugins.awesome-vim-colorschemes
    pkgs.vimPlugins.nvim-web-devicons
  ];
  config.nvim.init.lua = lib.mkIf config.nvim.layers.pimp (
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
  config.nvim.post.vim = lib.mkIf config.nvim.layers.pimp (
    builtins.concatStringsSep "\n" [
      ''" Pimp layer''
      (
        if (is_colorscheme "neon")
        then ''
          let g:neon_style = "dark"
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
        if (isnt_colorscheme "catppuccino") then ''
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
    
