{ lib, pkgs, config, ... }:
let
  case = builtins.getAttr config.spacenix.case {
    smart = { ignore = "true"; smart = "true"; };
    match = { ignore = "false"; smart = "false"; };
    nomatch = { ignore = "true"; smart = "false"; };
  };
  linenumbers = builtins.getAttr config.spacenix.line-numbers {
    on = { number = "true"; relative = "false"; };
    off = { number = "false"; relative = "false"; };
    relative = { number = "true"; relative = "true"; };
  };
  enabled = config.spacenix.layers.base.enable;
in
{
  config.nvim.init = lib.mkIf enabled {
    vim = ''
      " General options defined in base layer
      if has("persistent_undo")
        let target_path = expand('${config.spacenix.backup-dir}')
        if !isdirectory(target_path)
            call mkdir(target_path, "p", 0700)
        endif
        let &undodir=target_path
        set undofile
      endif
      set noswapfile

      set mouse+=a
      " End of general options defined in base layer
    '';
    lua = ''
      -- General options defined in base layer
      vim.g.mapleader = "${config.spacenix.which-key.leader}"
      vim.g.maplocalleader = "${config.spacenix.which-key.localleader}"
      vim.o.ignorecase = ${case.ignore}
      vim.o.smartcase = ${case.smart}
      vim.o.hlsearch = ${if config.spacenix.highlight-search then "true" else "false"}
      vim.o.incsearch = ${if config.spacenix.incsearch then "true" else "false"}
      vim.o.expandtab = ${if config.spacenix.expandtab then "true" else "false"}
      vim.wo.number = ${linenumbers.number}
      vim.wo.relativenumber = ${linenumbers.relative}
      vim.o.textwidth = ${builtins.toString config.spacenix.textwidth}
      vim.o.shiftwidth = ${builtins.toString config.spacenix.tabwidth}
      vim.o.tabstop = ${builtins.toString config.spacenix.tabwidth}
      vim.o.scrolloff = ${builtins.toString config.spacenix.scrolloff}
      vim.o.cursorline = ${if config.spacenix.cursorline then "true" else "false"}
      vim.o.cursorcolumn = ${if config.spacenix.cursorcolumn then "true" else "false"}
      -- End of general options defined in base layer
    '';
  };
}
