{ config, lib, ... }:
let
  enabled = config.nvim.layers.debugger.enable;
in
{
  config.nvim.which-key = lib.mkIf enabled {
    groups = [
      { prefix = "<localleader>d"; name = "+Debugger"; }
    ];
    bindings = [
      { key = "<localleader>dd"; command = "<cmd>lua require('dapui').toggle()<cr><cmd>DapVirtualTextToggle<cr>"; description = "UI"; }
      { key = "<localleader>db"; command = "<cmd>lua require('dap').toggle_breakpoint()<cr>"; description = "Breakpoint"; }
      { key = "<localleader>ds"; command = "<cmd>lua require('dap').stop()<cr>"; description = "Stop"; }
      { key = "<localleader>dc"; command = "<cmd>lua require('dap').continue()<cr>"; description = "Continue/Start"; }
      { key = "<localleader>dn"; command = "<cmd>lua require('dap').step_over()<cr>"; description = "Step over"; }
      { key = "<localleader>di"; command = "<cmd>lua require('dap').step_into()<cr>"; description = "Step into"; }
    ];
  };
}
