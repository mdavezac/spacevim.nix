{ config, lib, pkgs, ... }:
let
  filetypes = [ "python" ];
in
{
  config.nvim.which-key = lib.mkIf config.nvim.layers.testing.enable {
    groups = [{
      prefix = "<localleader>t";
      name = "+Testing";
      filetypes = filetypes;
    }];
    bindings = [
      {
        key = "<localleader>tt";
        command = "<cmd>UltestNearest<cr>";
        description = "Nearest test";
        filetypes = filetypes;
      }
      {
        key = "<localleader>tf";
        command = ''<cmd>Ultest<cr>'';
        description = "Test file";
        filetypes = filetypes;
      }
      {
        key = "<localleader>ts";
        command = "<cmd>TestSuite<cr>";
        description = "Run full test-suite";
        filetypes = filetypes;
      }
      {
        key = "<localleader>tl";
        command = "<cmd>TestLast<cr>";
        description = "Run last test";
        filetypes = filetypes;
      }
      {
        key = "<localleader>tv";
        command = "<cmd>TestVisit<cr>";
        description = "Open last test file";
        filetypes = filetypes;
      }
      {
        key = "<localleader>to";
        command = "<cmd>UltestOutput<cr>";
        description = "Show lastest output for nearest test";
        filetypes = filetypes;
      }
      {
        key = "<localleader>t<localleader>";
        command = "<cmd>UltestSummary<cr>";
        description = "Toggle summary window";
        filetypes = filetypes;
      }
    ];
  };
}
