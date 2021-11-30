{
  inputs = {
    omnisharp-vim = { url = "github:OmniSharp/omnisharp-vim"; flake = false; };
  };
  outputs = { self, ... }: {
    module = { config, lib, pkgs, ... }: {
      options.nvim = lib.mkOption {
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
            };
            default = { };
          };
        };
      };
      imports = [ ./python.nix ./nix.nix ];
      config.nvim.plugins.start = [ pkgs.vimPlugins.vim-commentary ];
    };
  };
}
