{ config, lib, pkgs, ... }:
let
  enableIf = lib.mkIf config.nvim.languages.markdown;
in
{
  config.nvim.plugins.start = enableIf [
    pkgs.vimPlugins.vim-markdown
    pkgs.vimPlugins.glow-nvim
  ];
  config.nvim.layers.completion.sources = enableIf {
    markdown = [
      {
        name = "treesitter";
        priority = 2;
        group_index = 2;
      }
      {
        name = "buffer";
        priority = 2;
        group_index = 2;
      }
    ];
  };
  config.nvim.init.lua = enableIf ''
    vim.g.glow_binary_path = "${pkgs.glow}/bin"
  '';
  config.nvim.init.vim = enableIf ''
    autocmd FileType markdown setlocal spell
  '';
  config.nvim.which-key.bindings = enableIf [
    {
      key = "<localleader>p";
      command = "<CMD>Glow<CR>";
      description = "Preview markdown";
      filetypes = [ "markdown" ];
    }
  ];
}
