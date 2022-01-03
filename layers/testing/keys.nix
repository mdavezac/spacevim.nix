{ config, lib, pkgs, ... }: {
  config.nvim.which-key.normal = lib.mkIf config.nvim.layers.testing.enable {
    ",t" = {
      name = "+testing";
      keys.t = {
        command = "<cmd>TestNearest<cr>";
        description = "Nearest test";
      };
      keys.f = {
        command = ''<cmd>TestFile<cr>'';
        description = "Test file";
      };
      keys.s = {
        command = "<cmd>TestSuite<cr>";
        description = "Run full test-suite";
      };
      keys.l = {
        command = "<cmd>TestLast<cr>";
        description = "Run last test";
      };
      keys.v = {
        command = "<cmd>TestVisit<cr>";
        description = "Open last test file";
      };
    };
  };
}
