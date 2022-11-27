{ config, lib, pkgs, ... }:
let
  cfg = config.spacenix.layers.pimp;
  lualine = cfg.enable && cfg.statusline == "lualine";
in
{
  config.nvim.plugins.start = lib.mkIf lualine [ pkgs.vimPlugins.lualine-nvim ];
  config.nvim.post.lua =
    let
      colorscheme =
        if (builtins.isNull config.spacenix.colorscheme)
        then "gruvbox" else config.spacenix.colorscheme;
    in
    lib.mkIf lualine
      ''
        require'lualine'.setup {
          options = {
              icons_enabled = true,
              theme = '${colorscheme}',
              component_separators = { left = '', right = ''},
              section_separators = { left = '', right = ''},
              disabled_filetypes = {},
              always_divide_middle = true,
              globalstatus = true,
          },
          sections = {
              lualine_a = {'mode'},
              lualine_b = {'branch', 'diff',
                          {'diagnostics', sources={'nvim_diagnostic'}},{"aerial"}},
              lualine_c = { 'filename' },
              lualine_x = {'encoding', 'fileformat', 'filetype'},
              lualine_y = {'progress'},
              lualine_z = {'location'}
          },
          inactive_sections = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = {'filename'},
              lualine_x = {'location'},
              lualine_y = {},
              lualine_z = {}
          },
          tabline = {},
          extensions = {}
        }
      '';
}
