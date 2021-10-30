{
  inputs = { };
  outputs = { self, ... }: {
    module = { config, lib, pkgs, ... }: {
      imports = [ ./python.nix ./nix.nix ];
    };
  };
}
