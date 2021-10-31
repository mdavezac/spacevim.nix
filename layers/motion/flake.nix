{
  inputs = { };
  outputs = { self, ... }: rec {
    module = { config, lib, pkgs, ... }: {
      config.nvim.plugins.start = lib.mkIf config.nvim.layers.git [
        pkgs.vimPlugins.hop-nvim
      ];
      config.nvim.which-key = lib.mkIf config.nvim.layers.git {
        "g" = {
          mode = "normal";
          keys.j = {
            command = "<cmd>HopChar1<cr>";
            description = "Git commits";
          };
        };
      };
    };
  };
}
    
