{ config, lib, pkgs, ... }: {
  imports = [ ./options.nix ];

  config.nvim.plugins.start = lib.mkIf config.nvim.layers.motion.enable [
    pkgs.vimPlugins.hop-nvim
  ];
  config.nvim.init.lua = lib.mkIf config.nvim.layers.motion.enable ''
    require('hop').setup()
  '';
  config.nvim.which-key = lib.mkIf config.nvim.layers.motion.enable {
    bindings = [
      {
        key = "gj";
        command = "<cmd>HopChar1<cr>";
        description = "Jump to character";
      }
      {
        key = "gJ";
        command = "<cmd>HopChar2<cr>";
        description = "Jump to two-character pattern";
      }
      {
        key = "gs";
        command = "<cmd>HopPattern<cr>";
        description = "Jump to regex pattern";
      }
    ];
  };
}
