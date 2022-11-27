{ lib, ... }: {
  options.spacenix = lib.mkOption {
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
              options.others = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Filetypes to include via vim-test";
              };
            };
            default = { };
          };
        };
      };
    };
  };
}
