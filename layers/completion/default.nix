{ lib, pkgs, config, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  with-treesitter = config.nvim.layers.treesitter.enable;
  enabled = config.nvim.layers.completion.enable;
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.completion = lib.mkOption {
            type = lib.types.submodule {
              options. enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the completion layer";
              };
            };
            default = { };
          };
        };
      };
    };
  };
  config.nvim.plugins.start = lib.mkIf enabled [
    pkgs.vimPlugins.nvim-cmp
    (lib.mkIf with-treesitter pkgs.vimPlugins.cmp-treesitter)
    (lib.mkIf (with-lsps || with-linters) pkgs.vimPlugins.cmp-nvim-lsp)
    pkgs.vimPlugins.cmp-buffer
    pkgs.vimPlugins.cmp-emoji
    pkgs.vimPlugins.cmp-path
  ];
  config.nvim.init.lua =
    let
      sources = builtins.concatStringsSep ",\n        " (
        (if with-treesitter then [ "{ name = 'treesitter' }" ] else [ ])
        ++ (if (with-lsps || with-linters) then [ "{ name = 'nvim_lsp' }" ] else [ ])
        ++ [
          "{ name = 'buffer' }"
          "{ name = 'emoji' }"
          "{ name = 'path' }"
        ]
      );
    in
    lib.mkIf
      enabled
      ''
        vim.o.completeopt = 'menuone,noselect'

        local cmp = require('cmp')
        cmp.setup {
          mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            },
            ['<Tab>'] = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
            ['<S-Tab>'] = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
          sources = {
              ${sources}
          },
        }
      '';
}
