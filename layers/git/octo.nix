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
}
