{ lib, ... }: {
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.tmux = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the tmux layer";
              };
            };
            default = { };
          };
        };
      };
    };
  };
}
