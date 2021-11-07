{ config, lib, pkgs, ... }: {
  config.nvim.which-key = lib.mkIf config.nvim.layers.git.enable {
    "<leader>g" = {
      name = "+git";
      mode = "normal";
      keys.c = {
        command = "<cmd>Telescope git_commit<cr>";
        description = "Git commits";
      };
      keys.s = {
        command = ''<cmd>Neogit kind=vsplit<cr>'';
        description = "Git status";
      };
      keys.b = {
        command = "<cmd>lua require('gitsigns').stage_buffer() <cr>";
        description = "Stage whole buffer";
      };
      keys.B = {
        command = "<cmd>lua require('gitsigns').reset_buffer() <cr>";
        description = "Reset whole buffer";
      };
      keys.p = {
        command = "<cmd>lua require('gitsigns').preview_hunk() <cr>";
        description = "Preview hunk";
      };
      keys.h = {
        command = "<cmd>lua require('gitsigns').stage_hunk() <cr>";
        description = "Stage hunk";
      };
      keys.H = {
        command = "<cmd>lua require('gitsigns').reset_hunk() <cr>";
        description = "Reset hunk";
      };
      keys.l = {
        command = "<cmd>lua require('gitsigns').blame_line(true) <cr>";
        description = "Blame line";
      };
    };
    "]" = {
      keys.c = {
        command = "<cmd>lua require('gitsigns.actions').next_hunk()<cr>";
        description = "Go to next hunk";
      };
    };
    "[" = {
      keys.c = {
        command = "<cmd>lua require('gitsigns.actions').prev_hunk()<cr>";
        description = "Go to next hunk";
      };
    };
  };
}
