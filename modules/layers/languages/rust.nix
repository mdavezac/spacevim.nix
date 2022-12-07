{ config, lib, pkgs, ... }:
let
  enableIf = lib.mkIf config.spacenix.languages.rust;
  with_debugger = config.spacenix.layers.debugger.enable && config.spacenix.languages.rust;
in
{
  config.spacenix.treesitter-languages = enableIf [ "rust" ];
  config.nvim.plugins.start =
    let
      conditional = condition: x: if condition then [ x ] else [ ];
    in
    enableIf [ pkgs.vimPlugins.rust-tools-nvim ];
  config.spacenix.layers.completion.sources = enableIf {
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
      {
        name = "luasnip";
        priority = 100;
        group_index = 3;
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
  config.spacenix.format-on-save = enableIf [ "*.rs" ];
  config.spacenix.dash.rust = [ "rust" ];
}
