{ config, lib, pkgs, ... }:
let
  cfg = config.nvim.layers.pimp;
  barbar = cfg.enable && cfg.tabline == "barbar";
in
{
  config.nvim.plugins.start = lib.mkIf barbar [ pkgs.vimPlugins.barbar-nvim ];
  config.nvim.post = lib.mkIf barbar {
    lua =
      ''
        -- Set barbar's options
        vim.g.bufferline = {
          -- Enable/disable animations
          animation = true,

          -- Enable/disable auto-hiding the tab bar when there is a single buffer
          auto_hide = false,

          -- Enable/disable current/total tabpages indicator (top right corner)
          tabpages = true,

          -- Enable/disable close button
          closable = false,

          -- Enables/disable clickable tabs
          --  - left-click: go to buffer
          --  - middle-click: delete buffer
          clickable = true,

          -- Excludes buffers from the tabline
          exclude_ft = {},
          exclude_name = {},

          -- Enable/disable icons
          -- if set to 'numbers', will show buffer index in the tabline
          -- if set to 'both', will show buffer index and icons in the tabline
          icons = true,

          -- If set, the icon color will follow its corresponding buffer
          -- highlight group. By default, the Buffer*Icon group is linked to the
          -- Buffer* group (see Highlighting below). Otherwise, it will take its
          -- default value as defined by devicons.
          icon_custom_colors = false,

          -- Configure icons on the bufferline.
          icon_separator_active = '▎',
          icon_separator_inactive = '▎',
          icon_close_tab = '',
          icon_close_tab_modified = '●',
          icon_pinned = '車',

          -- If true, new buffers will be inserted at the start/end of the list.
          -- Default is to insert after current buffer.
          insert_at_end = false,
          insert_at_start = false,

          -- Sets the maximum padding width with which to surround each tab
          maximum_padding = 1,

          -- Sets the maximum buffer name length.
          maximum_length = 30,

          -- If set, the letters for each buffer in buffer-pick mode will be
          -- assigned based on their name. Otherwise or in case all letters are
          -- already assigned, the behavior is to assign letters in order of
          -- usability (see order below)
          semantic_letters = true,

          -- New buffer letters are assigned in this order. This order is
          -- optimal for the qwerty keyboard layout but might need adjustement
          -- for other layouts.
          letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

          -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
          -- where X is the buffer number. But only a static string is accepted here.
          no_name_title = nil,
        }
      '';
  };
  config.nvim.which-key = lib.mkIf barbar {
    "<leader>b" = {
      keys.n = {
        command = "<cmd>BufferNext<cr>";
        description = "Next buffer";
      };
      keys.N = {
        command = "<cmd>BufferMoveNext<cr>";
        description = "Reorder buffer forward";
      };
      keys.p = {
        command = "<cmd>BufferPrevious<cr>";
        description = "Previous buffer";
      };
      keys.P = {
        command = "<cmd>BufferMovePrevious<cr>";
        description = "Reorder buffer backward";
      };
      keys."[\",\"]" = {
        command = "<cmd>BufferPick<cr>";
        description = "Pick buffer via letter";
      };
      keys.t = {
        command = "<cmd>BufferPin<cr>";
        description = "Pin/Unpin buffer";
      };
      keys.o = {
        command = "<cmd>BufferOrderByBufferNumber<cr>";
        description = "Order by buffer number";
      };
      keys.O = {
        command = "<cmd>BufferOrderByDirectory<cr>";
        description = "Order by directory";
      };
      keys.C = {
        command = "<cmd>BufferCloseAllButPinned<cr>";
        description = "Close all but pinned buffer";
      };
      keys.d = {
        command = "<cmd>BufferClose<cr>";
        description = "Delete current buffer";
      };
      keys.D = {
        command = "<cmd>BufferClose!<cr>";
        description = "Delete current buffer forcibly";
      };
    };
    "g" = {
      keys.b = {
        command = "<cmd>BufferPick<cr>";
        description = "Pick buffer via letter";
      };
    };
  };
}
