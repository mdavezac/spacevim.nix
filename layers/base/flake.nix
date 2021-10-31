{
  inputs = { };
  outputs = { self, ... }: rec {
    module = { config, lib, pkgs, ... }: {
      imports = [ ./which_key.nix ./general_options.nix ];
      config.nvim.plugins.start = lib.mkIf config.nvim.layers.base
        [ pkgs.vimPlugins.telescope-nvim pkgs.vimPlugins.which-key-nvim ];
      config.nvim.which-key = lib.mkIf config.nvim.layers.base {
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
          keys.n = {
            command = "<cmd>bnew<cr>";
            description = "New buffer";
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
          keys.o = {
            command = "<cmd>Telescopt treesitter<cr>";
            description = "Search syntax nodes of current buffer";
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
      };
    };
  };
}
