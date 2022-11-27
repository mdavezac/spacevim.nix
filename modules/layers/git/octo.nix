{ lib, config, pkgs, ... }:
let
  enable = config.spacenix.layers.git.enable && config.spacenix.layers.git.github;
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

  config.spacenix.which-key = lib.mkIf enable {
    groups = [
      { prefix = "<leader>o"; name = "+Github"; }
      { prefix = "<leader>oe"; name = "+Emote"; filetypes = [ "octo" ]; }
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
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>ob";
        command = "<cmd> Octo pr browser <cr>";
        description = "Open pr in browser";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>ov";
        command = "<cmd> Octo pr checks <cr>";
        description = "Check checks";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>od";
        command = "<cmd> Octo pr changes <cr>";
        description = "List changes per file";
        filetypes = [ "octo" ];
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
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>oR";
        command = "<cmd> Octo review close <cr>";
        description = "Stop review";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>os";
        command = "<cmd> Octo review start <cr>";
        description = "Start review";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>oS";
        command = "<cmd> Octo review submit <cr>";
        description = "Submit review";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>oeu";
        command = "<cmd> Octo reaction thumbs_up<cr>";
        description = "👍";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>oed";
        command = "<cmd> Octo reaction thumbs_down<cr>";
        description = "👎";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>oee";
        command = "<cmd> Octo reaction eyes<cr>";
        description = "👀";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>oeh";
        command = "<cmd> Octo reaction hooray<cr>";
        description = "🙌";
        filetypes = [ "octo" ];
      }
      {
        key = "<leader>oep";
        command = "<cmd> Octo reaction party<cr>";
        description = "🎉";
        filetypes = [ "octo" ];
      }
    ];
  };
}
