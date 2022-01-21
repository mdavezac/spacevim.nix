{ config, lib, pkgs, ... }:
let
  cfg = config.nvim.layers;
  enable = cfg.terminal.enable;
  enable-repl = enable && cfg.terminal.repl.enable && (
    (builtins.length (builtins.attrValues cfg.terminal.repl)) > 0
  );
in
{
  config.nvim.which-key = lib.mkIf enable {
    normal = {
      "<leader>" = {
        keys."[\";\"]" = {
          command = "<cmd>lua term_toggle()<cr>";
          description = "Toggle terminal and focus";
        };
        keys."[\"<CR>\"]" = lib.mkIf enable-repl {
          command = "<Plug>(iron-send-line)";
          description = "Send line to REPL";
        };
      };
      "<leader>t" = {
        keys.t = {
          command = "<cmd>lua require'nterm.main'.term_toggle()<cr>";
          description = "Toggle terminal without focussing";
        };
      };
      "<leader>r" = lib.mkIf enable-repl {
        name = "+REPL";
        keys.r = {
          command = "<CMD>IronRepl<CR>";
          description = "Toggle REPL";
        };
        keys.l = {
          command = "<Plug>(iron-send-line)";
          description = "Send line to REPL";
        };
        keys.t = {
          command = "<Plug>(iron-send-motion)";
          description = "Send motion to REPL";
        };
      };
    };
    visual."".keys."[\"<CR>\"]" = lib.mkIf enable-repl {
      command = "<Plug>(iron-visual-send)";
      description = "Send selection to REPL";
    };
  };
}
