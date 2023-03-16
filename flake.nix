{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";

    neovim = {
      url = "github:neovim/neovim/v0.8.3?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # base
    nvim-telescope.url = "github:nvim-telescope/telescope.nvim";
    nvim-telescope.flake = false;
    # pimp
    dressing.url = "github:stevearc/dressing.nvim";
    dressing.flake = false;
    rainglow.url = "github:rainglow/vim";
    rainglow.flake = false;
    neon.url = "github:rafamadriz/neon";
    neon.flake = false;
    catpuccino.url = "github:catppuccin/nvim";
    catpuccino.flake = false;
    nvim-notify.url = "github:rcarriga/nvim-notify";
    nvim-notify.flake = false;
    lush.url = "github:rktjmp/lush.nvim";
    lush.flake = false;
    zenbones.url = "github:mcchrish/zenbones.nvim";
    zenbones.flake = false;
    monochrome.url = "github:kdheepak/monochrome.nvim";
    monochrome.flake = false;
    oh-lucy.url = "github:Yazeed1s/oh-lucy.nvim";
    oh-lucy.flake = false;
    nightfox.url = "github:EdenEast/nightfox.nvim";
    nightfox.flake = false;
    bluloco.url = "github:uloco/bluloco.nvim";
    bluloco.flake = false;
    nvim-animate.url = "github:echasnovski/mini.animate";
    nvim-animate.flake = false;
    # lsp
    nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    nvim-cmp.flake = false;
    cmp-cmdline.url = "github:hrsh7th/cmp-cmdline";
    cmp-cmdline.flake = false;
    nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    nvim-lspconfig.flake = false;
    guihua.url = "github:ray-x/guihua.lua";
    guihua.flake = false;
    lsp-navigator.url = "github:ray-x/navigator.lua";
    lsp-navigator.flake = false;
    lspsaga-nvim.url = "github:tami5/lspsaga.nvim";
    lspsaga-nvim.flake = false;
    trouble-nvim.url = "github:folke/trouble.nvim";
    trouble-nvim.flake = false;
    # treesitter
    nvim-treesitter-textsubjects.url = "github:RRethy/nvim-treesitter-textsubjects";
    nvim-treesitter-textsubjects.flake = false;
    vim-illuminate.url = "github:RRethy/vim-illuminate";
    vim-illuminate.flake = false;
    nvim-spellsitter.url = "github:lewis6991/spellsitter.nvim";
    nvim-spellsitter.flake = false;
    tree-climber.url = "github:Dkendal/nvim-treeclimber";
    tree-climber.flake = false;
    # git
    octo.url = "github:pwntester/octo.nvim";
    octo.flake = false;
    vim-diffview.url = "github:sindrets/diffview.nvim";
    vim-diffview.flake = false;
    vim-hydra.url = "github:anuvyklack/hydra.nvim";
    vim-hydra.flake = false;
    # dash
    dash-nvim.url = "github:mrjones2014/dash.nvim/6296e87fddece1996c7d324ef8511d6908184a55";
    dash-nvim.flake = false;
    # testing
    neotest.url = "github:nvim-neotest/neotest";
    neotest.flake = false;
    neotest-python.url = "github:nvim-neotest/neotest-python";
    neotest-python.flake = false;
    neotest-vim-test.url = "github:nvim-neotest/neotest-vim-test";
    neotest-vim-test.flake = false;
    # terminal
    iron-nvim.url = "github:hkupty/iron.nvim";
    iron-nvim.flake = false;
    flatten-nvim.url = "github:willothy/flatten.nvim";
    flatten-nvim.flake = false;
    # neorg
    neorg.url = "github:nvim-neorg/neorg";
    neorg.flake = false;
    #
    aniseed.url = "github:olical/aniseed";
    aniseed.flake = false;
    # debugger
    nvim-dap-python.url = "github:mfussenegger/nvim-dap-python";
    nvim-dap-python.flake = false;

    #
    legendary.url = "github:mrjones2014/legendary.nvim";
    legendary.flake = false;

    # haskell
    haskell-tools-nvim.url = "github:MrcJkb/haskell-tools.nvim/1.8.0";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    neovim,
    flake-utils,
    devshell,
    haskell-tools-nvim,
    ...
  }: let
    local_default = import ./.;
    make-overlay = self: k: v:
      self.vimUtils.buildVimPluginFrom2Nix {
        pname = k;
        version = v.shortRev;
        src = v;
      };
    nvim-plugins = self:
      builtins.mapAttrs
      (make-overlay self)
      (builtins.removeAttrs inputs [
        "self"
        "nixpkgs"
        "flake-utils"
        "devshell"
        "neovim"
        "dash-nvim"
        "haskell-tools-nvim"
      ]);
    systemized = flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {allowUnfree = true;};
          overlays = [
            devshell.overlay
            self.overlay
            neovim.overlay
            (final: prev: {
              python = prev.python3;
            })
            haskell-tools-nvim.overlays.haskell-tooling-overlay
          ];
        };
      in rec {
        lib.spacenix-wrapper = local_default.customNeovim pkgs;
        modules.prepackaged = (import ./modules/prepackaged.mod.nix) {
          wrapper = local_default.customNeovim;
          prepackaged_pkgs = pkgs;
        };
        packages.default = local_default.customNeovim pkgs local_default.default_config;
        apps = rec {
          nvim = flake-utils.lib.mkApp {
            drv = packages.default;
            name = "nvim";
          };
          default = nvim;
        };

        devShells.default = pkgs.devshell.mkShell {
          name = "neovim";
          imports = [self.modules.devshell self.modules."${system}".prepackaged {config = local_default.default_config;}];
        };
      }
    );
  in rec {
    inherit (systemized) packages apps devShells lib;
    overlay = final: super: rec {
      spacenix-wrapper = local_default.customNeovim;
      vimPlugins =
        super.vimPlugins
        // {
          dash-nvim = final.vimUtils.buildVimPluginFrom2Nix {
            pname = "dash-nvim";
            version = inputs.dash-nvim.shortRev;
            src = inputs.dash-nvim;
            buildPhase = "make install";
          };
        }
        // (nvim-plugins final);
    };
    modules =
      systemized.modules
      // {
        spacevim = import ./modules/raw.nix;
        devshell = import ./modules/devshell.mod.nix;
      };
  };
}
