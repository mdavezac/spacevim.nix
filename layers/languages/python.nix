{ config, lib, pkgs, ... }: {
  config.nvim.treesitter-languages = lib.mkIf config.nvim.layers.python [ "python" ];
  config.nvim.lsp-instances = lib.mkIf config.nvim.layers.python [ "pyright" ];
  config.nvim.formatters = lib.mkIf config.nvim.layers.python {
    black = {
      exe = "${pkgs.black}/bin/black";
      args = [ "-q" "-" ];
      filetype = "python";
      enable = true;
    };
  };
  config.nvim.linters = lib.mkIf config.nvim.layers.python {
    "diagnostics.flake8" = {
      exe = "${pkgs.python38Packages.flake8}/bin/flake8";
      enable = false;
    };
  };
}
