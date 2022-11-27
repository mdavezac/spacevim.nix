{ lib, pkgs, config, ... }:
let
  enabled = config.spacenix.layers.debugger.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enabled [
    pkgs.vimPlugins.nvim-dap
    pkgs.vimPlugins.nvim-dap-ui
    pkgs.vimPlugins.nvim-dap-virtual-text
  ];
  config.nvim.init.lua = lib.mkIf enabled ''
    require("dapui").setup()
    require("nvim-dap-virtual-text").setup()
    require('dap')
    vim.fn.sign_define('DapBreakpoint', {text="🔴", texthl="", linehl="", numhl=""})
  '';
}
