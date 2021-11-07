{ config, lib, pkgs, ... }:
let
  tree-sitter = languages: (import ./tree-sitter.nix) {
    inherit (pkgs) stdenv lib writeTextFile curl git cacert neovim;
    languages = lib.sort (a: b: a < b) languages;
    nvim-treesitter-src = pkgs.vimPlugins.nvim-treesitter;
  };
  enabled =
    config.nvim.layers.treesitter.enable
    && ((builtins.length config.nvim.treesitter-languages) > 0);
in
{
  config.nvim.plugins.start = lib.mkIf enabled
    [
      pkgs.vimPlugins.nvim-treesitter
      pkgs.vimPlugins.nvim-treesitter-textobjects
      pkgs.vimPlugins.nvim-treesitter-context
      (tree-sitter config.nvim.treesitter-languages)
    ];
  config.nvim.init.lua = lib.mkIf enabled
    ''
      require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
      }

      require'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      }

      require'treesitter-context'.setup{
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
                'class',
                'function',
                'method',
                -- 'for', -- These won't appear in the context
                -- 'while',
                -- 'if',
                -- 'switch',
                -- 'case',
            },
        },
      }
    '';
  config.nvim.post.vim = lib.mkIf enabled
    ''
      " Tree-sitter layer
      set foldmethod=expr
      set foldlevel=10
      set foldexpr=nvim_treesitter#foldexpr()
      " End of tree-sitter layer
    '';
  config.nvim.post.lua = lib.mkIf (enabled && config.nvim.layers.base.enable) ''
    require('which-key').register({
      ["if"] = [[function body]],
      ["af"] = [[function]],
      ["ic"] = [[class body]],
      ["ac"] = [[class]],
    }, {mode="o", prefix=""})
  '';
}
