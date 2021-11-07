{
  inputs = { };
  outputs = { self, ... }: rec {
    module = { config, lib, pkgs, ... }: {
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
      config.nvim.which-key = lib.mkIf config.nvim.layers.motion.enable {
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
