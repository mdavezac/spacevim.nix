{
  inputs = { };
  outputs = { self, ... }: rec {
    module = { config, lib, pkgs, ... }: {
      config.nvim.plugins.start = lib.mkIf config.nvim.layers.motion [
        pkgs.vimPlugins.hop-nvim
      ];
      config.nvim.which-key = lib.mkIf config.nvim.layers.motion {
        "g" = {
          mode = "normal";
          keys.j = {
            command = "<cmd>HopChar1<cr>";
            description = "Jump to a character";
          };
          keys.J = {
            command = "<cmd>HopChar2<cr>";
            description = "Jump to a two-character pattern";
          };
          keys.r = {
            command = "<cmd>HopPattern<cr>";
            description = "Jump to a regex pattern";
          };
        };
      };
    };
  };
}
    
