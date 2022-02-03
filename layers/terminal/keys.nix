{ config, lib, pkgs, ... }:
let
  cfg = config.nvim.layers;
  enable = cfg.terminal.enable;
  repl-filetypes = builtins.attrNames cfg.terminal.repl.favored;
  enable-repl = enable && cfg.terminal.repl.enable && (
    (builtins.length repl-filetypes) > 0
  );
in
{
  config.nvim.which-key = lib.mkIf enable {
    bindings = [
      {
        key = "<leader>;";
        command = "<cmd>lua term_toggle()<cr>";
        description = "Toggle terminal and focus";
      }
      {
        key = "<leader>tt";
        command = "<cmd>lua require'nterm.main'.term_toggle()<cr>";
        description = "Toggle terminal without focussing";
      }
      (lib.mkIf enable-repl
        {
          key = "<CR>";
          command = "<Plug>(iron-visual-send)";
          description = "Send selection to REPL";
          modes = [ "visual" ];
          filetypes = repl-filetypes;
        })
      (lib.mkIf enable-repl
        {
          key = "<leader><CR>";
          command = "<Plug>(iron-send-line)";
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
          command = "<Plug>(iron-send-line)";
          description = "Send line to REPL";
          filetypes = repl-filetypes;
        })
      (lib.mkIf enable-repl
        {
          key = "<leader>rt";
          command = "<Plug>(iron-send-motion)";
          description = "Send motion to REPL";
          filetypes = repl-filetypes;
        })
    ];
  };
}
