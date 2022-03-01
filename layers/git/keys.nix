{ config, lib, pkgs, ... }: {
  config.nvim.which-key = lib.mkIf config.nvim.layers.git.enable {
    groups = [{ prefix = "<leader>g"; name = "+Git"; }];
    bindings = [
      { key = "<leader>gc"; command = "<cmd>Telescope git_commit<cr>"; description = "Commits"; }
      { key = "<leader>gs"; command = ''<cmd>Neogit kind=vsplit<cr>''; description = "Status"; }
      {
        key = "<leader>gb";
        command = "<cmd>lua require('gitsigns').stage_buffer() <cr>";
        description = "Stage whole buffer";
      }
      {
        key = "<leader>gX";
        command = "<cmd>lua require('gitsigns').reset_buffer() <cr>";
        description = "Reset whole buffer";
      }
      {
        key = "<leader>gp";
        command = "<cmd>lua require('gitsigns').preview_hunk() <cr>";
        description = "Preview hunk";
      }
      {
        key = "<leader>gh";
        command = "<cmd>lua require('gitsigns').stage_hunk() <cr>";
        description = "Stage hunk";
      }
      {
        key = "<leader>gH";
        command = "<cmd>lua require('gitsigns').undo_stage_hunk() <cr>";
        description = "Undo stage hunk";
      }
      {
        key = "<leader>gx";
        command = "<cmd>lua require('gitsigns').reset_hunk() <cr>";
        description = "Reset hunk";
      }
      {
        key = "<leader>gl";
        command = "<cmd>lua require('gitsigns').blame_line{full=true} <cr>";
        description = "Blame line";
      }
      {
        key = "<leader>gt";
        command = "<cmd>Gitsigns toggle_current_line_blame<cr>";
        description = "Toggle blame in codelens";
      }
      {
        key = "<leader>gf";
        command = "<cmd>DiffviewFileHistory<cr>";
        description = "File history";
      }
      {
        key = "<leader>gd";
        command = "<cmd>DiffviewToggle<cr>";
        description = "Diff view";
      }
      {
        key = "]h";
        command = "<cmd>lua require('gitsigns.actions').next_hunk()<cr>";
        description = "Hunk";
      }
      {
        key = "[h";
        command = "<cmd>lua require('gitsigns.actions').prev_hunk()<cr>";
        description = "Hunk";
      }
    ];
  };
}
