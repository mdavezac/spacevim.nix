{ config, lib, pkgs, ... }:
let
  linters-enabled = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  enabled = config.nvim.layers.lsp.enable && (
    ((builtins.length config.nvim.lsp-instances) > 0) || linters-enabled
  );
in
{
  config.nvim.plugins.start = lib.mkIf enabled [
    pkgs.vimPlugins.nvim-cmp
    (lib.mkIf config.nvim.layers.treesitter.enable pkgs.vimPlugins.cmp-treesitter)
    pkgs.vimPlugins.cmp-nvim-lsp
    pkgs.vimPlugins.cmp-buffer
    pkgs.vimPlugins.cmp-emoji
    pkgs.vimPlugins.cmp-path
  ];
  config.nvim.post.lua =
    lib.mkIf enabled ''
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
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'emoji' },
          { name = 'path' },
        },
      }
    '';
}
