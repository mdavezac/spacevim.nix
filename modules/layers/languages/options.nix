{lib, ...}: {
  options.spacenix = lib.mkOption {
    type = lib.types.submodule {
      options.languages = lib.mkOption {
        type = lib.types.submodule {
          options.python = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the python language layer";
          };
          options.nix = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the nix language layer";
          };
          options.markdown = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the markdown language layer";
          };
          options.rust = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the rust language layer";
          };
          options.haskell = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the haskell language layer";
          };
        };
        default = {};
      };
    };
  };
}
