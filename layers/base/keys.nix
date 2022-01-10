{ config, lib, tools, ... }:
let
  cfg = config.nvim.layers;
  barbar = cfg.pimp.enable && cfg.pimp.tabline == "barbar";
  switch_pane = {
    keys."[\"<C-h>\"]" = {
      command = "<C-[><C-w>h";
      description = "Go to one pane left";
    };
    keys."[\"<C-j>\"]" = {
      command = "<C-[><C-w>j";
      description = "Go to one pane down";
    };
    keys."[\"<C-k>\"]" = {
      command = "<C-[><C-w>k";
      description = "Go to one pane up";
    };
    keys."[\"<C-l>\"]" = {
      command = "<C-[><C-w>l";
      description = "Go to one pane right";
    };
  };
in
{
  config.nvim.which-key.normal = lib.mkIf config.nvim.layers.base.enable {
    "<leader>f" = {
      name = "+file";
      keys.f = {
        command = "<cmd>Telescope find_files<cr>";
        description = "Find File";
      };
      keys.g = {
        command = "<cmd>Telescope git_files<cr>";
        description = "Open files from git repo";
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
      keys.b = {
        command = "<cmd>Telescope buffers<cr>";
        description = "Find buffer";
      };
      keys."[\"<TAB>\"]" = {
        command = "<cmd>b#<cr>";
        description = "Switch back to last buffer";
      };
    } // (if barbar then { } else {
      keys.d = {
        command = "<cmd>bdel<cr>";
        description = "Delete current buffer";
      };
      keys.D = {
        command = "<cmd>bdel!<cr>";
        description = "Delete current buffer forcibly";
      };
    });
    "<leader>w" = {
      name = "+windows";
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
      keys."[\"=\"]" = {
        command = "<C-w>=";
        description = "Equalize window sizes";
      };
    };
    "<leader>s" = {
      name = "+search";
      keys.s = {
        command = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
        description = "Search current buffer";
      };
      keys.p = {
        command = "<cmd>Telescope live_grep<cr>";
        description = "Search current project";
      };
      keys.g = {
        command = "<cmd>Telescope grep_string<cr>";
        description = "Search current project for string under cursor";
      };
      keys.h = {
        command = "<cmd>Telescope command_history<cr>";
        description = "Search command history";
      };
      keys."[\"/\"]" = {
        command = "<cmd>Telescope search_history<cr>";
        description = "Search search history";
      };
      keys."[\" \"]" = {
        command = "<cmd>nohlsearch<cr>";
        description = "Turn off current search highlight";
      };
    };
    "<leader>t" = {
      name = "+themes and toggles";
      keys.c = {
        command = "<cmd>Telescope colorscheme<cr>";
        description = "Search and apply colorscheme";
      };
      keys.L =
        let
          command = builtins.concatStringsSep "; " [
            "local is_on = vim.o.relativenumber and vim.o.number"
            "vim.o.number = not is_on"
            "vim.o.relativenumber = not is_on"
          ];
        in
        {
          command = "<cmd>lua ${command}<CR>";
          description = "Toggle relative line numbers";
        };
      keys.l =
        let
          command = builtins.concatStringsSep "; " [
            "local is_on = vim.o.number and not vim.o.relativenumber"
            "vim.o.number = not is_on"
            "vim.o.relativenumber = false;"
          ];
        in
        {
          command = "<cmd>lua ${command}<CR>";
          description = "Toggle absolute line numbers";
        };
    };
    "]" = {
      keys.b = {
        command = "<cmd>bnext<cr>";
        description = "Next buffer";
      };
      keys.t = {
        command = "<cmd>tabNext<cr>";
        description = "Next tab";
      };
      keys.q = {
        command = "<cmd>cnext<cr>";
        description = "Next quickfix";
      };
    };
    "[" = {
      keys.b = {
        command = "<cmd>bprevious<cr>";
        description = "Previous buffer";
      };
      keys.t = {
        command = "<cmd>tabprevious<cr>";
        description = "Previous tab";
      };
      keys.q = {
        command = "<cmd>cprev<cr>";
        description = "Previous quickfix";
      };
    };
    "" = {
      keys."[\"<C-q>\"]" = {
        command = "<cmd>q<cr>";
        description = "Quit current window";
      };
    } // lib.mkIf (!config.nvim.layers.tmux.enable) switch_pane;
    "<leader>" = {
      keys.q = {
        command = "<cmd>q<cr>";
        description = "Quit current window";
      };
      keys."[\"<TAB>\"]" = {
        command = "<cmd>b#<cr>";
        description = "Switch back to last buffer";
      };
    };
  };
  config.nvim.which-key.visual = lib.mkIf
    (config.nvim.layers.base.enable &&
      (!config.nvim.layers.tmux.enable))
    switch_pane;
  config.nvim.which-key.insert = lib.mkIf
    (config.nvim.layers.base.enable &&
      (!config.nvim.layers.tmux.enable))
    switch_pane;
}
