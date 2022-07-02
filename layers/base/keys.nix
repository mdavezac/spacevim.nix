{ config, lib, ... }:
let
  cfg = config.nvim.layers;
  barbar = cfg.pimp.enable && cfg.pimp.tabline == "barbar";
  enable-tmux = config.nvim.layers.tmux.enable;
in
{
  config.nvim.which-key = lib.mkIf config.nvim.layers.base.enable {
    groups = [
      { prefix = "<leader>f"; name = "+File"; }
      { prefix = "<leader>b"; name = "+Buffer"; }
      { prefix = "<leader>w"; name = "+Window&Tabs"; }
      { prefix = "<leader>s"; name = "+Search"; }
      { prefix = "<leader>t"; name = "+Toggles"; }
    ];
    bindings = [
      { key = "<leader>ff"; command = "<cmd>Telescope find_files<cr>"; description = "Find"; }
      {
        key = "<leader>fg";
        command = "<cmd>Telescope git_files<cr>";
        description = "Repo only";
      }
      { key = "<leader>fr"; command = "<cmd>Telescope oldfiles<cr>"; description = "Recent"; }
      { key = "<leader>fn"; command = "<cmd>enew<cr>"; description = "New"; }
      {
        key = "<leader>fi";
        command = "<cmd>view ${placeholder "out"}<cr>";
        description = "Open vim.init";
      }
      { key = "<leader>ft"; command = "<cmd>NvimTreeToggle<cr>"; description = "File tree"; }
      { key = "<leader>fT"; command = "<cmd>NvimTreeFindFile<cr>"; description = "Current file in tree"; }
      { key = "<leader>bb"; command = "<cmd>Telescope buffers<cr>"; description = "Find"; }
      { key = "<leader>b<TAB>"; command = "<cmd>b#<cr>"; description = "Switch to last"; }
      {
        key = "<leader>bu";
        command = "<cmd>UndotreeToggle<cr>";
        description = "Undotree";
      }
      {
        key = "<leader><leader>";
        command = "<cmd>b#<cr>";
        description = "Switch to last buffer";
      }
      (lib.mkIf (!barbar)
        { key = "<leader>bd"; command = "<cmd>bdel<cr>"; description = "Delete"; })
      (lib.mkIf (!barbar)
        { key = "<leader>bD"; command = "<cmd>bdel!<cr>"; description = "Force delete"; })
      { key = "<leader>wh"; command = "<cmd>split<cr>"; description = "Horizontal split"; }
      { key = "<leader>wv"; command = "<cmd>vsplit<cr>"; description = "Vertical split"; }
      { key = "<leader>w="; command = "<C-w>="; description = "Equalize size"; }
      { key = "<leader>wz"; command = "<C-w>|"; description = "Zoom"; }
      { key = "<leader>wc"; command = "<CMD>tabc<CR>"; description = "Close tab"; }
      {
        key = "<leader>ss";
        command = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
        description = "Buffer";
      }
      { key = "<leader>sp"; command = "<cmd>Telescope live_grep<cr>"; description = "Project"; }
      {
        key = "<leader>sg";
        command = "<cmd>Telescope grep_string<cr>";
        description = "Project with word under cursor";
      }
      {
        key = "<leader>s/";
        command = "<cmd>Telescope search_history<cr>";
        description = "Search-history";
      }
      {
        key = "<leader>sq";
        command = "<cmd>Telescope command_history<cr>";
        description = "Command-history";
      }
      {
        key = "<leader>s<leader>";
        command = "<cmd>nohlsearch<cr>";
        description = "Turn-off search highlight";
      }
      {
        key = "<leader>sc";
        command = "<cmd>Telescope colorscheme<cr>";
        description = "colorschemes";
      }
      {
        key = "<leader>tl";
        command = "<CMD>" + (builtins.concatStringsSep ";" [
          "lua local is_on = vim.o.number and not vim.o.relativenumber"
          "vim.o.number = not is_on"
          "vim.o.relativenumber = false;"
        ]) + "<CR>";
        description = "Absolute line numbers";
      }
      {
        key = "<leader>tL";
        command = "<CMD>" + (builtins.concatStringsSep ";" [
          "lua local is_on = vim.o.number and vim.o.relativenumber"
          "vim.o.number = not is_on"
          "vim.o.relativenumber = true and not is_on;"
        ]) + "<CR>";
        description = "Relative line numbers";
      }
      { key = "]b"; command = "<CMD>bnext<CR>"; description = "Buffer"; }
      { key = "[b"; command = "<CMD>bprevious<CR>"; description = "Buffer"; }
      { key = "]t"; command = "<CMD>tabNext<CR>"; description = "Tab"; }
      { key = "[t"; command = "<CMD>tabNext<CR>"; description = "Tab"; }
      { key = "]q"; command = "<CMD>cnext<CR>"; description = "Quickfix"; }
      { key = "[q"; command = "<CMD>cprevious<CR>"; description = "Quickfix"; }
      { key = "]l"; command = "<CMD>lnext<CR>"; description = "Location"; }
      { key = "[l"; command = "<CMD>lprevious<CR>"; description = "Location"; }
      (lib.mkIf (!enable-tmux)
        {
          key = "<C-h>";
          command = "<ESC><C-w>h";
          description = "Go to one pane left";
          modes = [ "normal" "visual" "insert" ];
        })
      (lib.mkIf (!enable-tmux)
        {
          key = "<C-j>";
          command = "<ESC><C-w>j";
          description = "Go to one pane down";
          modes = [ "normal" "visual" "insert" ];
        })
      (lib.mkIf (!enable-tmux)
        {
          key = "<C-k>";
          command = "<ESC><C-w>k";
          description = "Go to one pane up";
          modes = [ "normal" "visual" "insert" ];
        })
      (lib.mkIf (!enable-tmux)
        {
          key = "<C-l>";
          command = "<ESC><C-w>l";
          description = "Go to one pane right";
          modes = [ "normal" "visual" "insert" ];
        })
      { key = "<leader>ts"; command = "<CMD>setlocal spell!<CR>"; description = "Spelling (local)"; }
      { key = "<leader>tS"; command = "<CMD>set spell!<CR>"; description = "Spelling (global)"; }
    ];
  };
}
