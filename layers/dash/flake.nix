{
  inputs = {
    dash-nvim = { url = "github:mrjones2014/dash.nvim"; flake = false; };
  };
  outputs = inputs @ { self, ... }: rec {
    overlay = (self: super: {
      vimPlugins = super.vimPlugins // {
        dash-nvim = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "dash-nvim";
          version = inputs.dash-nvim.shortRev;
          src = inputs.dash-nvim;
          buildPhase = "make install";
        };
      };
    });
    module = { config, lib, pkgs, ... }: { imports = [ ./options.nix ./config.nix ]; };
  };
}
