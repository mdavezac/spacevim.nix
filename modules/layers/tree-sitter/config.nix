{ config, lib, pkgs, ... }:
let
  enabled =
    config.spacenix.layers.treesitter.enable
    && ((builtins.length config.spacenix.treesitter-languages) > 0);
in
{
  config.nvim.plugins.start = with pkgs.vimPlugins; lib.mkIf enabled [
    (nvim-treesitter.withPlugins
      (plugins: builtins.map
        (k: builtins.getAttr "tree-sitter-${k}" plugins)
        config.spacenix.treesitter-languages))
    nvim-treesitter-textobjects
    nvim-treesitter-context
    nvim-treesitter-textsubjects
    vim-illuminate
    (lib.mkIf config.spacenix.layers.treesitter.spelling nvim-spellsitter)
    tree-climber
    lush # for tree-climber
  ];
  config.nvim.init.lua = lib.mkIf enabled (
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
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
        },
        textsubjects = {
            enable = true,
            prev_selection = ',', -- (Optional) keymap to select the previous selection
            keymaps = {
                ['.'] = 'textsubjects-smart',
                ['a;'] = 'textsubjects-container-outer',
                ['i;'] = 'textsubjects-container-inner',
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

      require('illuminate').configure({
        providers = { "treesitter", "lsp" },
        filetype_denylist = { "NeogitStatus", "octo" }
      })


    '' + (
      if config.spacenix.layers.treesitter.spelling then
        ''
          require('spellsitter').setup()
        ''
      else ""
    )
  );
  config.nvim.post.vim = lib.mkIf
    enabled
    ''
      " Tree-sitter layer
      set foldmethod=expr
      set foldlevel=10
      set foldexpr=nvim_treesitter#foldexpr()
      " End of tree-sitter layer
    '';
  config.nvim.post.lua = lib.mkIf enabled ''
    local tc = require('nvim-treeclimber')
    local hint = [[
    _v_: Current node   _k_: Control flow   _p_: Expand    _c_: Shrink
    _e_: Forward        _b_: Backward       _]_: Next      _[_: Previous
    _t_: Top            ^                   _}_: Add next  _{_: Add previous
    ^
    ^ ^ ^  _q_: exit
    ]]
    require('hydra')({
          name = 'Tree climber',
          hint = hint,
          config = {
             buffer = bufnr,
             color = 'amaranth',
             invoke_on_body = true,
             foreign_keys = 'warn',
             hint = {
                border = 'rounded',
                type = 'window',
                position = 'bottom-right'
             },
          },
          mode = {'n','x'},
          body = '<leader>x',
          heads = {
             { 'v', tc.select_current_node, { desc = "Select current node" } },
             { 'k', tc.show_control_flow, { desc = "Show control flow" } },
             { 'p', tc.select_expand, { desc = "Select parent node" } },
             { 'e', tc.select_forward_end, { desc = "Select forward" } },
             { 'b', tc.select_backward, { desc = "Select backward" } },
             { '[', tc.select_sibling_backward, { desc = "Select previous sibling" } },
             { ']', tc.select_sibling_forward, { desc = "Select next sibling" } },
             { 't', tc.select_top_level, { desc = "Select top level node" } },
             { 'c', tc.select_shrink, { desc = "Select child node" } },
             { '{', tc.select_grow_backward, { desc = "Add previous sibling node" } },
             { '}', tc.select_grow_forward, { desc = "Add next sibling node" } },
             { 'q', nil, { exit = true, nowait = true, desc = 'exit' } },
          }
       }) 
  '';
}
