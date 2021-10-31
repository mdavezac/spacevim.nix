{ config, lib, pkgs, ... }: {
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
    pkgs.vimPlugins.awesome-vim-colorschemes
    pkgs.vimPlugins.nvim-web-devicons
  ];
  config.nvim.post.lua = lib.mkIf config.nvim.layers.pimp (builtins.concatStringsSep "\n" [
    ''
      -- Pimp layer
      require'nvim-web-devicons'.setup {
       default = true;
      }
    ''
    # (lib.mkIf config.nvim.colorscheme != "neon"
    #   ''
    #     require('lualine').setup {
    #       options = {
    #         theme = 'neon'
    #       }
    #     }
    #   ''
    # )
    ''-- End of pimp layer''
  ]);
  config.nvim.init.vim = lib.mkIf config.nvim.layers.pimp (
    builtins.concatStringsSep "\n" [
      ''" Pimp layer''
      (if (!(builtins.isNull config.nvim.colorscheme) && config.nvim.colorscheme == "neon")
      then ''
        let g:neon_style = "dark"
        let g:neon_italic_keyword = 1
        let g:neon_italic_function = 1
        let g:neon_transparent = 1
      ''
      else ""
      )
      (if (builtins.isNull config.nvim.colorscheme) then ""
      else "colorscheme ${config.nvim.colorscheme}")
      ''" End of pimp layer''
    ]
  );
}
    
