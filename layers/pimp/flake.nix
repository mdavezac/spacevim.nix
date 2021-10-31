{
  inputs = {
    rainglow = { url = "github:rainglow/vim"; flake = false; };
    neon = { url = "github:rafamadriz/neon"; flake = false; };
  };
  outputs = inputs @ { self, ... }: rec {
    overlay = (super: self: {
      vimPlugins = self.vimPlugins // {
        rainglow = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "rainglow";
          version = inputs.rainglow.shortRev;
          src = inputs.rainglow;
        };
        neon = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "neon";
          version = inputs.neon.shortRev;
          src = inputs.neon;
        };
      };
    });
    module = { config, lib, pkgs, ... }: {
      imports = [ ./colorschemes.nix ./tabline.nix ./statusline.nix ];
    };
  };
}
    
