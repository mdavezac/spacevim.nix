{ lib, pkgs, config, ... }:
let
  enabled = config.spacenix.layers.base.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enabled [
    pkgs.vimPlugins.dressing
    pkgs.vimPlugins.legendary
  ];
  config.nvim.init = lib.mkIf enabled {
    lua = ''
      require("legendary").setup({
        which_key = {
            auto_register = true;
        },
      })
      require('dressing').setup({
       select = {
         get_config = function(opts)
           if opts.kind == 'legendary.nvim' then
             return {
               telescope = {
                 sorter = require('telescope.sorters').fuzzy_with_index_bias({})
               }
             }
           else
             return {}
           end
         end
       }
      })
    '';
  };
  config.spacenix.which-key = lib.mkIf enabled {
    bindings = [
      {
        key = "<C-SPACE>";
        command = "<cmd>Legendary<cr>";
        description = "Palette";
      }
    ];
  };
}
