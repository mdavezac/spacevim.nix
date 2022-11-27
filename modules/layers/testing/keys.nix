{ config, lib, pkgs, ... }:
let
  add_if = condition: value: (if condition then value else [ ]);
  conditions = (import ./utils.nix) config;
  filetypes = (add_if conditions.is_python_enabled [ "python" ]) ++ (
    add_if conditions.is_others_enabled config.layers.testing.others
  );
  with_debug = config.spacenix.layers.debugger.enable;
in
{
  config.spacenix.which-key = lib.mkIf conditions.is_enabled {
    groups = [{
      prefix = "<localleader>t";
      name = "+Testing";
      filetypes = filetypes;
    }];
    bindings = [
      {
        key = "<localleader>tt";
        command = ''<cmd>lua require('neotest').run.run()<cr>'';
        description = "Nearest test";
        filetypes = filetypes;
      }
      {
        key = "<localleader>tf";
        command = ''<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>'';
        description = "Test file";
        filetypes = filetypes;
      }
      {
        key = "<localleader>tl";
        command = "<cmd>lua require('neotest').run.run_last()<cr>";
        description = "Run last test";
        filetypes = filetypes;
      }
      {
        key = "<localleader>to";
        command = "<cmd>lua require('neotest').output.open({})<cr>";
        description = "Show lastest output for nearest test";
        filetypes = filetypes;
      }
      {
        key = "<localleader>t<localleader>";
        command = "<cmd>lua require('neotest').summary.toggle()<cr>";
        description = "Toggle summary window";
        filetypes = filetypes;
      }
      {
        key = "<localleader>td";
        command = "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>";
        description = "Step into";
      }
    ];
  };
}
