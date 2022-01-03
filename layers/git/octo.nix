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

  config.nvim.which-key.normal."<leader>o" = lib.mkIf enable {
    name = "+github";
    keys.o = {
      command = "<cmd> Octo pr list <cr>";
      description = "List all prs";
    };
    keys.O = {
      command = "<cmd> Octo pr checkout <cr>";
      description = "Checkout current PR";
    };
    keys.b = {
      command = "<cmd> Octo pr browser <cr>";
      description = "Open pr in browser";
    };
    keys.v = {
      command = "<cmd> Octo pr checks <cr>";
      description = "Check checks";
    };
    keys.d = {
      command = "<cmd> Octo pr changes <cr>";
      description = "List changes per file";
    };
    keys.c = {
      command = "<cmd> Octo comment add <cr>";
      description = "Add comment";
    };
    keys.C = {
      command = "<cmd> Octo comment delete <cr>";
      description = "Delete comment";
    };
    keys.r = {
      command = "<cmd> Octo review resume <cr>";
      description = "Resume review";
    };
    keys.R = {
      command = "<cmd> Octo review close <cr>";
      description = "Stop review";
    };
    keys.s = {
      command = "<cmd> Octo review start <cr>";
      description = "Start review";
    };
    keys.S = {
      command = "<cmd> Octo review submit <cr>";
      description = "Submit review";
    };
  };
  config.nvim.which-key.normal."<leader>oe" = lib.mkIf enable {
    name = "+emote";
    keys.u = {
      command = "<cmd> Octo reaction thumbs_up<cr>";
      description = "👍";
    };
    keys.d = {
      command = "<cmd> Octo reaction thumbs_down<cr>";
      description = "👎";
    };
    keys.e = {
      command = "<cmd> Octo reaction eyes<cr>";
      description = "👀";
    };
    keys.h = {
      command = "<cmd> Octo reaction hooray<cr>";
      description = "🙌";
    };
    keys.p = {
      command = "<cmd> Octo reaction party<cr>";
      description = "🎉";
    };
  };
}
