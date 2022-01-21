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
    (lib.mkIf enable pkgs.vimPlugins.nterm-nvim)
    (lib.mkIf enable pkgs.vimPlugins.aniseed)
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
            (builtins.mapAttrs (k: v: ''${k} = "${v}",'') cfg.terminal.repl.favored)
        );
        repl = ''
          local iron = require('iron');
          iron.core.set_config {
              preferred = {
                    ${preferred}
              },
              repl_open_cmd = ${cfg.terminal.repl.repl-open-cmd},
          }
        '';
      in
      builtins.concatStringsSep "\n" [
        nterm
        (if enable-repl then repl else "")
      ];
    vim = ''
      tnoremap <C-h> <C-\><C-N><C-w>h
      tnoremap <C-j> <C-\><C-N><C-w>j
      tnoremap <C-k> <C-\><C-N><C-w>k
      tnoremap <C-l> <C-\><C-N><C-w>l
      tnoremap <C-[> <C-\><C-N>
      tnoremap <C-q> <C-\><C-N><CMD>q<CR>
    '';
  };
  config.nvim.post.lua = lib.mkIf (enable && cfg.base.enable) ''
    require('telescope').load_extension('nterm')
  '';
  config.nvim.post.vim = lib.mkIf enable-repl ''
    let g:iron_map_defaults = 0
    let g:iron_map_extended = 0
  '';
}
