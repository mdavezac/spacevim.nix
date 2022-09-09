{ lib, ... }:
let
  git_options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the git layer";
    };
    auto_refresh = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to auto-refresh the neogit window";
    };
    github = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable github integration";
    };
  };
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.layers = lib.mkOption {
        type = lib.types.submodule {
          options.git = lib.mkOption {
            type = lib.types.submodule {
              options = git_options;
            };
            default = { };
          };
        };
      };
    };
  };
}
