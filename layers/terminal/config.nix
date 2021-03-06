{ config, lib, pkgs, ... }:
let
  cfg = config.nvim.layers;
  enable = cfg.terminal.enable;
  enable-repl = enable && cfg.terminal.repl.enable && (
    (builtins.length (builtins.attrValues cfg.terminal.repl)) > 0
  );
in
{
  config.nvim.plugins.start = [
    (lib.mkIf enable pkgs.vimPlugins.toggleterm-nvim)
    (lib.mkIf enable-repl pkgs.vimPlugins.iron-nvim)
  ];
  config.nvim.init = lib.mkIf enable {
    lua =
      let
        nterm = ''
          require'nterm.main'.init({
            maps = false,  -- load defaut mappings
            shell = "${pkgs.fish}/bin/fish",
            size = 102,
            direction = "vertical", -- horizontal or vertical
            popup = 2000,     -- Number of miliseconds to show the info about the commmand. 0 to dissable
            popup_pos = "SE", --  one of "NE" "SE" "SW" "NW"
            autoclose = 2000, -- If command is sucesful, close the terminal after that number of miliseconds. 0 to disable
          })


          function term_toggle()
              local nterm = require('nterm.main')
              nterm.term_toggle()
              nterm.term_focus()
              vim.cmd('startinsert')
          end
        '';
        preferred = builtins.concatStringsSep "\n        " (
          builtins.attrValues
            (builtins.mapAttrs (k: v: ''${k} = ${v},'') cfg.terminal.repl.favored)
        );
        repl = ''
            local iron = require('iron.core');
            iron.setup({
          config = {
                  repl_definition = {
                        ${preferred}
                  },
                  repl_open_cmd = ${cfg.terminal.repl.repl-open-cmd},
          }
            })
        '';
        toggleterm = ''
          require("toggleterm").setup {
              size=100,
              shell="${pkgs.fish}/bin/fish",
              direction="vertical",
              insert_mappings=false,
              terminal_mappings=false,
          }

          function _G.set_terminal_keymaps()
            local opts = {noremap = true}
            vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
            vim.api.nvim_buf_set_keymap(0, 't', '<C-[>', [[<C-\><C-n>]], opts)
            vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
            vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
            vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
            vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
          end
          vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        '';
      in
      builtins.concatStringsSep "\n" [
        toggleterm
        (if enable-repl then repl else "")
      ];
  };
  /* config.nvim.post.lua = lib.mkIf (enable && cfg.base.enable) '' */
  /*   require('telescope').load_extension('nterm') */
  /* ''; */
  config.nvim.post.vim = lib.mkIf enable-repl ''
    let g:iron_map_defaults = 0
    let g:iron_map_extended = 0
  '';
}
