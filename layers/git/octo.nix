{ lib, config, pkgs, ... }:
let
  enable = config.nvim.layers.git.enable && config.nvim.layers.git.github;
in
{
  config.nvim.plugins.start = lib.mkIf enable [ pkgs.vimPlugins.octo ];
  config.nvim.init = lib.mkIf enable {
    lua = ''
        require"octo".setup({
            default_remote = {"upstream", "origin"}; -- order to try remotes
            reaction_viewer_hint_icon = "";         -- marker for user reactions
            user_icon = " ";                        -- user icon
            timeline_marker = "";                   -- timeline marker
            timeline_indent = "2";                   -- timeline indentation
            right_bubble_delimiter = "";            -- Bubble delimiter
            left_bubble_delimiter = "";             -- Bubble delimiter
            github_hostname = "";                    -- GitHub Enterprise host
            snippet_context_lines = 4;               -- number or lines around commented lines
            file_panel = {
              size = 10,                             -- changed files panel rows
              use_icons = true                       -- use web-devicons in file panel
            },
            mappings = {}
      })
    '';
  };

  config.nvim.which-key = lib.mkIf enable {
    groups = [
      { prefix = "<leader>o"; name = "+github"; }
      { prefix = "<leader>oe"; name = "+emote"; }
    ];
    bindings = [
      {
        key = "<leader>oo";
        command = "<cmd> Octo pr list <cr>";
        description = "List PRs";
      }
      {
        key = "<leader>oO";
        command = "<cmd> Octo pr checkout <cr>";
        description = "Checkout current PR";
      }
      {
        key = "<leader>ob";
        command = "<cmd> Octo pr browser <cr>";
        description = "Open pr in browser";
      }
      {
        key = "<leader>ov";
        command = "<cmd> Octo pr checks <cr>";
        description = "Check checks";
      }
      {
        key = "<leader>od";
        command = "<cmd> Octo pr changes <cr>";
        description = "List changes per file";
      }
      {
        key = "<leader>oc";
        command = "<cmd> Octo comment add <cr>";
        description = "Add comment";
      }
      {
        key = "<leader>oC";
        command = "<cmd> Octo comment delete <cr>";
        description = "Delete comment";
      }
      {
        key = "<leader>or";
        command = "<cmd> Octo review resume <cr>";
        description = "Resume review";
      }
      {
        key = "<leader>oR";
        command = "<cmd> Octo review close <cr>";
        description = "Stop review";
      }
      {
        key = "<leader>os";
        command = "<cmd> Octo review start <cr>";
        description = "Start review";
      }
      {
        key = "<leader>oS";
        command = "<cmd> Octo review submit <cr>";
        description = "Submit review";
      }
      {
        key = "<leader>oeu";
        command = "<cmd> Octo reaction thumbs_up<cr>";
        description = "👍";
      }
      {
        key = "<leader>oed";
        command = "<cmd> Octo reaction thumbs_down<cr>";
        description = "👎";
      }
      {
        key = "<leader>oee";
        command = "<cmd> Octo reaction eyes<cr>";
        description = "👀";
      }
      {
        key = "<leader>oeh";
        command = "<cmd> Octo reaction hooray<cr>";
        description = "🙌";
      }
      {
        key = "<leader>oep";
        command = "<cmd> Octo reaction party<cr>";
        description = "🎉";
      }
    ];
  };
}
