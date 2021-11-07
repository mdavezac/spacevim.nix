{
  inputs = { };
  outputs = { self, ... }: {
    module = { config, lib, pkgs, ... }: {
      imports = [ ./options.nix ./formatter.nix ./keys.nix ];
    };
  };
}
