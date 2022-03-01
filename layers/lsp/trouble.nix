{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.linters);
  with-any-lsp = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  enabled = config.nvim.layers.lsp.enable && (with-any-lsp || with-linters);
  with-trouble = lib.mkIf (enabled && config.nvim.layers.lsp.trouble);
in
{
  config.nvim.plugins.start = with-trouble [ pkgs.vimPlugins.trouble-nvim ];
  config.nvim.init = with-trouble {
    lua = ''
      require("trouble").setup({
        action_keys = {
            close = {"q", "tq"}, -- close the list
            cancel = {"esc", "tc"}, -- cancel the preview and get back to your last window / buffer / cursor
            refresh = {"r", "tr"}, -- manually refresh
            jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
            open_split = { "ts" }, -- open buffer in new split
            open_vsplit = { "tv" }, -- open buffer in new vsplit
            open_tab = { "tt" }, -- open buffer in new tab
            jump_close = {"o", "to"}, -- jump to the diagnostic and close the list
            toggle_mode = {"m", "tm"}, -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = {"P", "tP"}, -- toggle auto_preview
            hover = {"K", "tK"}, -- opens a small popup with the full multiline message
            preview = {"p", "tp"}, -- preview the diagnostic location
            close_folds = {"zM", "zm"}, -- close all folds
            open_folds = {"zR", "zr"}, -- open all folds
            toggle_fold = {"zA", "za"}, -- toggle fold of current file
            previous = "k", -- preview item
            next = "j" -- next item
        }
      })
      local actions = require("telescope.actions")
      local trouble = require("trouble.providers.telescope")
      require("telescope").setup {
        defaults = {
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
      }
    '';
  };
  config.nvim.which-key = with-trouble {
    groups = [
      { name = "Trouble"; prefix = "t"; filetypes = [ "Trouble" ]; }
    ];
    bindings = [
      { key = "q"; description = "Close Trouble"; filetypes = [ "Trouble" ]; }
      { key = "tq"; description = "Close Trouble"; filetypes = [ "Trouble" ]; }
      { key = "tc"; description = "Cancel Preview"; filetypes = [ "Trouble" ]; }
      { key = "tr"; description = "Refresh"; filetypes = [ "Trouble" ]; }
      { key = "ts"; description = "Open in split"; filetypes = [ "Trouble" ]; }
      { key = "tv"; description = "Open in vertical split"; filetypes = [ "Trouble" ]; }
      { key = "tt"; description = "Open in tab"; filetypes = [ "Trouble" ]; }
      { key = "tm"; description = "Workspace vs Document"; filetypes = [ "Trouble" ]; }
      { key = "tP"; description = "Toggle autopreview"; filetypes = [ "Trouble" ]; }
      { key = "tK"; description = "View message"; filetypes = [ "Trouble" ]; }
      { key = "tp"; description = "Preview location"; filetypes = [ "Trouble" ]; }
      {
        key = "<leader>sr";
        command = "<cmd>Trouble lsp_references<cr>";
        description = "References";
      }
      {
        key = "<localleader>r";
        command = "<cmd>Trouble lsp_references<cr>";
        description = "References";
      }
      {
        key = "<localleader>q";
        command = "<cmd>Trouble quickfix<cr>";
        description = "Quickfix";
      }
      {
        key = "<leader>sq";
        command = "<cmd>Trouble quickfix<cr>";
        description = "Quickfix";
      }
      {
        key = "<localleader>L";
        command = "<cmd>Trouble loclist<cr>";
        description = "Loclist";
      }
      {
        key = "<localleader>d";
        command = "<cmd>TroubleToggle<cr>";
        description = "Diagnostics";
      }
      {
        key = "]r";
        command = "<CMD>lua require('trouble').next({skip_groups = true, jump = true})<CR>";
        description = "Trouble";
      }
      {
        key = "[r";
        command = "<CMD>lua require('trouble').previous({skip_groups = true, jump = true})<CR>";
        description = "Trouble";
      }
    ];
  };
}
