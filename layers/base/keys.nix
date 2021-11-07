{ config, lib, tools, ... }: {
  config.nvim.which-key = lib.mkIf config.nvim.layers.base.enable {
    "<leader>f" = {
      name = "+file";
      mode = "normal";
      keys.f = {
        command = "<cmd>Telescope find_files<cr>";
        description = "Find File";
      };
      keys.g = {
        command = "<cmd>Telescope git_files<cr>";
        description = "Open Recent File";
      };
      keys.r = {
        command = "<cmd>Telescope oldfiles<cr>";
        description = "Open Recent File";
      };
      keys.n = {
        command = "<cmd>enew<cr>";
        description = "New File";
      };
      keys.i = {
        command = "<cmd>view ${placeholder "out"}<cr>";
        description = "View spacevim.nix's init.vim";
      };
    };
    "<leader>b" = {
      name = "+buffers";
      mode = "normal";
      keys.b = {
        command = "<cmd>Telescope buffers<cr>";
        description = "Find buffer";
      };
      keys.c = {
        command = "<cmd>bnew<cr>";
        description = "Create new buffer";
      };
      keys.d = {
        command = "<cmd>bdel<cr>";
        description = "Delete current buffer";
      };
      keys.D = {
        command = "<cmd>bdel!<cr>";
        description = "Delete current buffer forcibly";
      };
    };
    "<leader>w" = {
      name = "+windows";
      mode = "normal";
      keys.s = {
        command = "<cmd>split<cr>";
        description = "Split horizontally";
      };
      keys.v = {
        command = "<cmd>vsplit<cr>";
        description = "Split vertically";
      };
      keys.c = {
        command = "<cmd>close<cr>";
        description = "Close current split";
      };
    };
    "<leader>s" = {
      name = "+search";
      mode = "normal";
      keys.s = {
        command = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
        description = "Search current buffer";
      };
      keys.h = {
        command = "<cmd>Telescope command_history<cr>";
        description = "Search command history";
      };
      keys."[\"/\"]" = {
        command = "<cmd>Telescope search_history<cr>";
        description = "Search search history";
      };
    };
    "<leader>t" = {
      name = "+themes and pimping";
      mode = "normal";
      keys.c = {
        command = "<cmd>Telescope colorscheme<cr>";
        description = "Search and apply colorscheme";
      };
    };
    "]" = {
      mode = "normal";
      keys.b = {
        command = "<cmd>bnext<cr>";
        description = "Go to next buffer";
      };
    };
    "[" = {
      mode = "normal";
      keys.b = {
        command = "<cmd>bprevious<cr>";
        description = "Go to previous buffer";
      };
    };
    "" = {
      mode = "normal";
      keys."[\"<C-q>\"]" = {
        command = "<cmd>q<cr>";
        description = "Quit current window";
      };
    };
    "<SPACE>" = {
      mode = "normal";
      keys.q = {
        command = "<cmd>q<cr>";
        description = "Quit current window";
      };
    };
  };
}
