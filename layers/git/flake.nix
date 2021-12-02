{
  inputs = {
    octo = { url = "github:pwntester/octo.nvim"; flake = false; };
  };
  outputs = inputs @ { self, ... }: {
    overlay = (self: super: {
      vimPlugins = super.vimPlugins // {
        octo = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "octo";
          version = inputs.octo.shortRev;
          src = inputs.octo;
        };
      };
    });
    module = { ... }: {
      imports = [ ./options.nix ./config.nix ./keys.nix ./octo.nix ];
    };
  };
}
