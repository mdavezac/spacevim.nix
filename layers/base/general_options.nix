{ lib, pkgs, config, ... }:
let
  case = builtins.getAttr config.nvim.case {
    smart = { ignore = "true"; smart = "true"; };
    match = { ignore = "false"; smart = "false"; };
    nomatch = { ignore = "true"; smart = "false"; };
  };
  linenumbers = builtins.getAttr config.nvim.line-numbers {
    on = { number = "true"; relative = "false"; };
    off = { number = "false"; relative = "false"; };
    relative = { number = "true"; relative = "true"; };
  };
  enabled = config.nvim.layers.base.enable;
in
{
  config.nvim.init = lib.mkIf enabled {
    vim = ''
      " General options defined in base layer
      if !isdirectory("$HOME/.local/share/spacevim/backup")
          silent !mkdir "$HOME/.local/share/spacevim/backup" > /dev/null 2>&1
      endif
      set undodir=$HOME/.local/share/spacevim/backup
      set undofile

      nnoremap <C-h> <C-[><C-w>h
      nnoremap <C-j> <C-[><C-w>j
      nnoremap <C-k> <C-[><C-w>k
      nnoremap <C-l> <C-[><C-w>l

      set mouse+=a
      " End of general options defined in base layer
    '';
    lua = ''
      -- General options defined in base layer
      vim.g.mapleader = "${config.nvim.leader}"
      vim.g.maplocalleader = "${config.nvim.localleader}"
      vim.o.ignorecase = ${case.ignore}
      vim.o.smartcase = ${case.smart}
      vim.o.hlsearch = ${if config.nvim.highlight-search then "true" else "false"}
      vim.o.incsearch = ${if config.nvim.incsearch then "true" else "false"}
      vim.o.expandtab = ${if config.nvim.expandtab then "true" else "false"}
      vim.wo.number = ${linenumbers.number}
      vim.wo.relativenumber = ${linenumbers.relative}
      vim.o.textwidth = ${builtins.toString config.nvim.textwidth}
      vim.o.shiftwidth = ${builtins.toString config.nvim.tabwidth}
      vim.o.tabstop = ${builtins.toString config.nvim.tabwidth}
      -- End of general options defined in base layer
    '';
  };
}
