{
  inputs = { };
  outputs = { self, ... }: rec {
    module = { config, lib, pkgs, ... }: {
      config.nvim.plugins.start = lib.mkIf config.nvim.layers.git [ pkgs.vimPlugins.neogit ];
      config.nvim.init.lua = lib.mkIf config.nvim.layers.git ''
        require('neogit').setup {}
      '';
      config.nvim.which-key = lib.mkIf config.nvim.layers.git {
        "<leader>g" = {
          name = "+git";
          mode = "normal";
          keys.c = {
            command = "<cmd>Telescope git_commit<cr>";
            description = "Git commits";
          };
          keys.s = {
            command = "<cmd>Neogit <cr>";
            description = "Git status";
          };
        };
      };
    };
  };
}
    
