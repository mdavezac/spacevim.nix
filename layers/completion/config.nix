{ lib, pkgs, config, ... }:
let
  with-linters = builtins.any (v: v.enable) (builtins.attrValues config.nvim.linters);
  with-lsps = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  with-treesitter = config.nvim.layers.treesitter.enable;
  with-norg = config.nvim.layers.neorg.enable;
  enabled = config.nvim.layers.completion.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enabled [
    pkgs.vimPlugins.nvim-cmp
    (lib.mkIf with-treesitter pkgs.vimPlugins.cmp-treesitter)
    (lib.mkIf (with-lsps || with-linters) pkgs.vimPlugins.cmp-nvim-lsp)
    pkgs.vimPlugins.cmp-buffer
    pkgs.vimPlugins.cmp-emoji
    pkgs.vimPlugins.cmp-path
  ];
  config.nvim.init =
    let
      print_source = source:
        let
          group_index = builtins.toString source.group_index;
          priority = builtins.toString source.priority;
        in
        "{ name=\"${source.name}\", group_index=${group_index}, priority=${priority} }";
      print_filetype = filetype: sources: (
        "   sources = {\n"
        + (
          builtins.concatStringsSep
            ",\n      "
            (builtins.map
              print_source
              (builtins.filter
                (k: builtins.any
                  (v: v == filetype || (filetype != ":" && filetype != "/" && v == "all"))
                  k.filetypes)
                sources)
            )
        ) + "   }\n"
      );
      print_filetype2 = sources: filetype: ''
        cmp.setup.filetype('${filetype}', {
            ${print_filetype filetype sources}
        })
      '';
      filetypes = sources: lib.unique (
        builtins.filter (k: k != "all" && k != "/" && k != ":")
          (lib.flatten (builtins.map (k: k.filetypes) sources))
      );
      print_all_sources = sources: builtins.concatStringsSep "\n" (
        builtins.map (print_filetype2 sources) (filetypes sources)
      );
    in
    lib.mkIf enabled {
      lua = ''
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
          ${print_filetype "all" config.nvim.layers.completion.sources}
        }
      '' + (print_all_sources config.nvim.layers.completion.sources);
    };
}
