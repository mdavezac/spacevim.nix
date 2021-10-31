{
  inputs = { };
  outputs = { self, ... }: {
    module = { config, lib, pkgs, ... }: {
      imports = [ ./lsp.nix ./linters.nix ./keys.nix ];
    };
  };
}
