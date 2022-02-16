{ config, lib, pkgs, ... }:
let
  enableIf = lib.mkIf config.nvim.languages.python;
in
{
  config.nvim.lsp-instances.pyright.cmd = [ "${pkgs.nodePackages.pyright}/bin/pyright-langserver" "--stdio" ];
  config.nvim.treesitter-languages = enableIf [ "python" ];
  config.nvim.plugins.start = lib.mkIf (config.nvim.languages.python && config.nvim.layers.treesitter.enable) [
    pkgs.vimPlugins.nvim-treesitter-pyfold
  ];
  config.nvim.layers.completion = enableIf {
    sources = [
      {
        name = "treesitter";
        priority = 2;
        group_index = 2;
        filetypes = [ "python" ];
      }
      {
        name = "nvim_lsp";
        priority = 2;
        group_index = 2;
        filetypes = [ "python" ];
      }
    ];
  };
  config.nvim.formatters = enableIf {
    black = {
      exe = "${pkgs.black}/bin/black";
      args = [ "-q" "-" ];
      filetype = "python";
      enable = true;
    };
    isort = {
      exe = "${pkgs.python39Packages.isort}/bin/isort";
      args = [ "-" ];
      filetype = "python";
      enable = true;
    };
  };
  config.nvim.format-on-save = enableIf [ "*.py" ];
  config.nvim.linters = enableIf {
    "diagnostics.flake8" = {
      exe = "${pkgs.python38Packages.flake8}/bin/flake8";
      enable = false;
    };
  };
  config.nvim.dash.python = enableIf [ "python3" ];
  config.nvim.post.lua = enableIf ''
    require('nvim-treesitter.configs').setup {
        pyfold = {
            enable = true,
            -- Sets provided foldtext on window where module is active
            custom_foldtext = true
        }
    }
  '';
  config.nvim.layers.terminal.repl.favored.python = "python";
}
