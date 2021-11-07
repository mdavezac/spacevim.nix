{
  inputs = {
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter?rev=0545b3de55781a4a28fdf01d2be771297c233b2b"; flake = false; };
  };
  outputs = inputs @ { self, ... }: rec {
    overlay = (self: super: {
      vimPlugins = super.vimPlugins // {
        nvim-treesitter = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-treesitter";
          version = inputs.nvim-treesitter.shortRev;
          src = inputs.nvim-treesitter;
        };
      };
    });
    module = { config, lib, pkgs, ... }: {
      imports = [ ./options.nix ./config.nix ./keys.nix ];
    };
  };
}
