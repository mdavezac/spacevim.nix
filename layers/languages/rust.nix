{ config, lib, pkgs, ... }:
let
  enableIf = lib.mkIf config.nvim.languages.rust;
  with_debugger = config.nvim.layers.debugger.enable && config.nvim.languages.rust;
in
{
  config.nvim.treesitter-languages = enableIf [ "rust" ];
  config.nvim.plugins.start =
    let
      conditional = condition: x: if condition then [ x ] else [ ];
    in
    enableIf [ pkgs.vimPlugins.rust-tools-nvim ];
  config.nvim.layers.completion.sources = enableIf {
    rust = [
      {
        name = "treesitter";
        priority = 2;
        group_index = 2;
      }
      {
        name = "nvim_lsp";
        priority = 2;
        group_index = 2;
      }
    ];
  };
  config.nvim.init.lua = enableIf ''
    local rt = require("rust-tools")
    rt.setup({
      server = {
        cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"};
      },
    })
  '';
  config.nvim.dash.rust = [ "rust" ];
}
