{ config, lib, pkgs, ... }: {
  config.nvim.lsp-instances.pyright.cmd = [
    "${pkgs.nodePackages.pyright}/bin/pyright-langserver"
    "--stdio"
  ];
  config.nvim.treesitter-languages = lib.mkIf config.nvim.languages.python [ "python" ];
  config.nvim.plugins.start = lib.mkIf (config.nvim.languages.python && config.nvim.layers.treesitter.enable) [
    pkgs.vimPlugins.nvim-treesitter-pyfold
  ];
  config.nvim.formatters = lib.mkIf config.nvim.languages.python {
    black = {
      exe = "${pkgs.black}/bin/black";
      args = [ "-q" "-" ];
      filetype = "python";
      enable = true;
    };
  };
  config.nvim.linters = lib.mkIf config.nvim.languages.python {
    "diagnostics.flake8" = {
      exe = "${pkgs.python38Packages.flake8}/bin/flake8";
      enable = false;
    };
  };
  config.nvim.dash.python = [ "python3" ];
  config.nvim.post.lua = ''
    require('nvim-treesitter.configs').setup {
        pyfold = {
            enable = true,
            -- Sets provided foldtext on window where module is active
            custom_foldtext = true
        }
    }
  '';
}
