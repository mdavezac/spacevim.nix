{ config, lib, pkgs, ... }: {
  config.nvim.treesitter-languages = lib.mkIf config.nvim.layers.python [ "python" ];
  config.nvim.lsp-instances = lib.mkIf config.nvim.layers.python [ "pyright" ];
  config.nvim.formatters.black = lib.mkIf config.nvim.layers.python {
    exe = "${pkgs.black}/bin/black";
    args = [ "-q" "-" ];
    filetype = "python";
    enable = true;
  };
}
