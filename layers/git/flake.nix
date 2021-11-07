{
  inputs = { };
  outputs = { self, ... }: {
    module = { ... }: {
      imports = [ ./options.nix ./config.nix ./keys.nix ];
    };
  };
}
