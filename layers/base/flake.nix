{
  inputs = {
    nvim-telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
  };
  outputs = inputs @ { self, ... }: rec {
    overlay = (self: super: {
      vimPlugins = super.vimPlugins // {
        telescope-nvim = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-telescope";
          version = inputs.nvim-telescope.shortRev;
          src = inputs.nvim-telescope;
        };
      };
    });
    module = { config, lib, pkgs, ... }:
      let
        enabled = config.nvim.layers.base.enable;
      in
      {
        imports = [ ./options.nix ./general_options.nix ./which_key.nix ./keys.nix ];
        config.nvim.plugins.start = lib.mkIf enabled
          [
            pkgs.vimPlugins.telescope-nvim
            pkgs.vimPlugins.plenary-nvim
            pkgs.vimPlugins.which-key-nvim
            pkgs.vimPlugins.telescope-fzy-native-nvim
          ];
        config.nvim.init.lua = lib.mkIf enabled ''
          require('telescope').load_extension('fzy_native')
        '';
      };
  };
}
