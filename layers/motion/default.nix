{ config, lib, pkgs, ... }: {
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.motion = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the motion layer";
              };
            };
            default = { };
          };
        };
      };
    };
  };

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
