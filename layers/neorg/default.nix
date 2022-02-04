{ config, lib, pkgs, ... }:
let
  enableIf = lib.mkIf config.nvim.layers.neorg.enable;
in
{
  config.nvim.plugins.start = enableIf [ pkgs.vimPlugins.neorg ];
  config.nvim.treesitter-languages = enableIf [ "norg" ];
  config.nvim.init.lua = ''
      require('neorg').setup {
        load = {
            ["core.defaults"] = {},
            ["core.norg.concealer"] = {},
            ["core.norg.completion"] = { config = { engine = "nvim-cmp" } },
            ["core.norg.dirman"] = {
                config = {
                    workspaces = {
                        work = "~/kagenova/notes",
                        home = "~/personal/notes",
                    }
                }
            }
        }
    }
  '';
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.neorg = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the neorg layer";
              };
            };
            default = { };
          };
        };
      };
    };
  };
}
