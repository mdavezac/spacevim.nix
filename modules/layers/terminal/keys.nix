{ config, lib, pkgs, ... }:
let
  cfg = config.spacenix.layers;
  enable = cfg.terminal.enable;
  repl-filetypes = builtins.attrNames cfg.terminal.repl.repls;
  enable-repl = enable && cfg.terminal.repl.enable && (
    (builtins.length repl-filetypes) > 0
  );
in
{
  config.spacenix.which-key = lib.mkIf enable {
    groups = lib.mkIf enable-repl [
      { prefix = "<leader>r"; name = "REPL"; }
    ];
    bindings = [
      {
        key = "<leader>;";
        command = "<cmd>ToggleTerm<cr>";
        description = "Toggle terminal and focus";
      }
      (lib.mkIf enable-repl
        {
          key = "<CR>";
          command = "<CMD>lua require('iron').core.visual_send()<CR>";
          description = "Send selection to REPL";
          modes = [ "visual" ];
          filetypes = repl-filetypes;
        })
      (lib.mkIf enable-repl
        {
          key = "<CR>";
          command = "<CMD>lua require('iron').core.send_line()<CR>j";
          description = "Send line to REPL";
          filetypes = repl-filetypes;
        })
      (lib.mkIf enable-repl
        {
          key = "<leader>rr";
          command = "<CMD>IronRepl<CR>";
          description = "Toggle REPL";
          filetypes = repl-filetypes;
        })
      (lib.mkIf enable-repl
        {
          key = "<leader>rl";
          command = "<CMD>lua require('iron').core.send_line()<CR>j";
          description = "Send line to REPL";
          filetypes = repl-filetypes;
        })
      (lib.mkIf enable-repl
        {
          key = "<leader>rt";
          command = "<CMD>lua require('iron').core.send_motion()<CR>j";
          description = "Send motion to REPL";
          filetypes = repl-filetypes;
        })
    ];
  };
}
