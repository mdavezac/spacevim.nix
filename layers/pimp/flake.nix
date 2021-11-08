{
  inputs = {
    rainglow = { url = "github:rainglow/vim"; flake = false; };
    neon = { url = "github:rafamadriz/neon"; flake = false; };
    catpuccino = { url = "github:Pocco81/Catppuccino.nvim"; flake = false; };
    nvim-notify = { url = "github:rcarriga/nvim-notify"; flake = false; };
    lush = { url = "github:rktjmp/lush.nvim"; flake = false; };
    zenbones = { url = "github:mcchrish/zenbones.nvim"; flake = false; };
    monochrome = { url = "github:kdheepak/monochrome.nvim"; flake=false; };
  };
  outputs = inputs @ { self, ... }: rec {
    overlay = (self: super: {
      vimPlugins = super.vimPlugins // {
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
        catpuccino = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "catpuccino";
          version = inputs.catpuccino.shortRev;
          src = inputs.catpuccino;
        };
        nvim-notify = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-notify";
          version = inputs.nvim-notify.shortRev;
          src = inputs.nvim-notify;
        };
        lush = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "lush";
          version = inputs.lush.shortRev;
          src = inputs.lush;
        };
        zenbones = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "zenbones";
          version = inputs.zenbones.shortRev;
          src = inputs.zenbones;
        };
        monochrome = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "monochrome";
          version = inputs.monochrome.shortRev;
          src = inputs.monochrome;
        };
      };
    });
    module = { config, lib, pkgs, ... }: {
      imports = [ ./options.nix ./colorschemes.nix ./tabline.nix ./statusline.nix ./notify.nix ];
    };
  };
}
