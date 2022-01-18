{ config, lib, pkgs, ... }:
let
  cfg = config.nvim.layers;
  enable = cfg.terminal.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enable [
    pkgs.vimPlugins.nterm-nvim
    pkgs.vimPlugins.aniseed
  ];
  config.nvim.init.lua = lib.mkIf enable ''
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
  config.nvim.post.lua = lib.mkIf (enable && cfg.base.enable) ''
    require('telescope').load_extension('nterm')
  '';
  config.nvim.init.vim = lib.mkIf enable ''
    tnoremap <C-h> <C-\><C-N><C-w>h
    tnoremap <C-j> <C-\><C-N><C-w>j
    tnoremap <C-k> <C-\><C-N><C-w>k
    tnoremap <C-l> <C-\><C-N><C-w>l
    tnoremap <C-[> <C-\><C-N>
    tnoremap <C-q> <C-\><C-N><CMD>q<CR>
  '';
}
