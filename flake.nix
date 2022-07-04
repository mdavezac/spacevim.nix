{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";

    neovim = {
      url = "github:neovim/neovim/v0.7.0?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # base
    nvim-telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    # pimp
    rainglow = { url = "github:rainglow/vim"; flake = false; };
    neon = { url = "github:rafamadriz/neon"; flake = false; };
    catpuccino = { url = "github:catppuccin/nvim"; flake = false; };
    nvim-notify = { url = "github:rcarriga/nvim-notify"; flake = false; };
    lush = { url = "github:rktjmp/lush.nvim"; flake = false; };
    zenbones = { url = "github:mcchrish/zenbones.nvim"; flake = false; };
    monochrome = { url = "github:kdheepak/monochrome.nvim"; flake = false; };
    # lsp
    nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    cmp-cmdline = { url = "github:hrsh7th/cmp-cmdline"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    guihua = { url = "github:ray-x/guihua.lua"; flake = false; };
    lsp-navigator = { url = "github:ray-x/navigator.lua"; flake = false; };
    lspsaga-nvim = { url = "github:tami5/lspsaga.nvim"; flake = false; };
    trouble-nvim = { url = "github:folke/trouble.nvim"; flake = false; };
    # treesitter
    nvim-treesitter-textsubjects = {
      url = "github:RRethy/nvim-treesitter-textsubjects";
      flake = false;
    };
    nvim-spellsitter = {
      url = "github:lewis6991/spellsitter.nvim";
      flake = false;
    };
    # git
    octo = { url = "github:pwntester/octo.nvim"; flake = false; };
    vim-diffview = { url = "github:sindrets/diffview.nvim"; flake = false; };
    # dash
    dash-nvim = {
      url = "github:mrjones2014/dash.nvim/6296e87fddece1996c7d324ef8511d6908184a55";
      flake = false;
    };
    # testing
    ultest = { url = "github:rcarriga/vim-ultest"; flake = false; };
    vim-test = { url = "github:vim-test/vim-test"; flake = false; };
    # terminal
    iron-nvim = { url = "github:hkupty/iron.nvim"; flake = false; };
    # neorg
    neorg = { url = "github:nvim-neorg/neorg"; flake = false; };
    #
    aniseed = { url = "github:olical/aniseed"; flake = false; };
  };

  outputs = inputs @ { self, nixpkgs, neovim, flake-utils, devshell, ... }:
    let
      modules_paths = [
        ./layers/base
        ./layers/tree-sitter
        ./layers/pimp
        ./layers/lsp
        ./layers/formatter
        ./layers/languages
        ./layers/git
        ./layers/motion
        ./layers/terminal
        ./layers/tmux
        ./layers/dash
        ./layers/testing
        ./layers/completion
        ./layers/neorg
      ];
      local_default = (import ./.) modules_paths;
      make-overlay = self: k: v: self.vimUtils.buildVimPluginFrom2Nix {
        pname = k;
        version = v.shortRev;
        src = v;
      };
      nvim-plugins = self: builtins.mapAttrs
        (make-overlay self)
        (builtins.removeAttrs inputs [ "self" "nixpkgs" "flake-utils" "devshell" "neovim" "dash-nvim" ]);
      overlay_ = final: super: rec {
        spacenix-wrapper = local_default.customNeovim;
        vimPlugins = super.vimPlugins // {
          dash-nvim = final.vimUtils.buildVimPluginFrom2Nix {
            pname = "dash-nvim";
            version = inputs.dash-nvim.shortRev;
            src = inputs.dash-nvim;
            buildPhase = "make install";
          };
        } // (nvim-plugins final);
        nvimDevShellSettings = pkgs: configuration:
          let
            nvim = spacenix-wrapper pkgs configuration;
            vicmd = ''
              rpc=$PRJ_DATA_DIR/nvim.rpc
              [ -e $rpc ] && ${pkgs.neovim-remote}/bin/nvr --servername $rpc -s $@ || ${nvim}/bin/nvim $@
            '';
            vi_args = [
              "${pkgs.neovim-remote}/bin/nvr"
              "--servername"
              "$PRJ_DATA_DIR/nvim.rpc"
              "-cc split"
              "--remote-wait"
              "-s"
              "$@"
            ];
          in
          {
            devshell.packages = [ nvim ];
            commands = builtins.map (x: { name = x; command = vicmd; }) [ "vim" "vi" ];
            env = [
              { name = "EDITOR"; value = builtins.concatStringsSep " " vi_args; }
              { name = "NVIM_LISTEN_ADDRESS"; eval = "$PRJ_DATA_DIR/nvim.rpc"; }
            ];
          };
      };
      overlays = {
        neovim = neovim.overlay;
        python = (final: prev: {
          python = prev.python3;
        });
        default = overlay_;

      };
    in
    {
      overlays = overlays;
    } //
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ devshell.overlay ] ++ (builtins.attrValues overlays);
        };
      in
      rec {
        packages.default = local_default.customNeovim pkgs local_default.default_config;
        lib.spacenix-wrapper = local_default.customNeovim pkgs;
        modules.devshell = import ./devshell.mod.nix;
        apps = rec {
          nvim = flake-utils.lib.mkApp {
            drv = packages.default;
            name = "nvim";
          };
          default = nvim;
        };

        devShells.default = pkgs.devshell.mkShell {
          name = "neovim";
          imports = [ (modules.devshell packages.default) ];
        };
      }
    );
}
