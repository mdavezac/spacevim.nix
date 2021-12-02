{ lib, ... }: {
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.git = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the git layer";
              };
              options.github = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable github integration";
              };
            };
            default = { };
          };
        };
      };
    };
  };
}
