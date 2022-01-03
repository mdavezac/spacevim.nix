{ lib, ... }: {
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.testing = lib.mkOption {
            type = lib.types.submodule {
              options.enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable the testing layer";
              };
              options.strategy = lib.mkOption {
                type = lib.types.enum [ "neovim" "basic" "make" "neoterm" ];
                default = "basic";
                description = "Where to run the tests";
              };
              options.python = lib.mkOption {
                type = lib.types.enum [
                  "pytest"
                  "nose"
                  "nose2"
                  "djangotest"
                  "djangonose"
                  "mamba"
                  "pyunit"
                ];
                default = "pytest";
                description = "Python test framework";
              };
            };
            default = { };
          };
        };
      };
    };
  };
}
