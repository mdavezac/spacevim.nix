{ config, lib, pkgs, ... }: {
  config.nvim.plugins.start = lib.mkIf config.nvim.layers.pimp [ pkgs.vimPlugins.nvim-notify ];
  config.nvim.post.lua = lib.mkIf config.nvim.layers.pimp ''
    require('notify').setup()
    vim.notify = require("notify")
    require("telescope").load_extension("notify")
  '';
  config.nvim.which-key = lib.mkIf config.nvim.layers.pimp {
    "<leader>s" = {
      keys.n = {
        command = "<cmd>Telescope notify<cr>";
        description = "Search notifications";
      };
    };
  };
}
    
