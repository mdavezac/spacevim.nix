{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";

    neovim = {
      url = "github:neovim/neovim/v0.6.1?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # base
    nvim-telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    # pimp
    rainglow = { url = "github:rainglow/vim"; flake = false; };
    neon = { url = "github:rafamadriz/neon"; flake = false; };
    catpuccino = { url = "github:Pocco81/Catppuccino.nvim"; flake = false; };
    nvim-notify = { url = "github:rcarriga/nvim-notify"; flake = false; };
    lush = { url = "github:rktjmp/lush.nvim"; flake = false; };
    zenbones = { url = "github:mcchrish/zenbones.nvim"; flake = false; };
    monochrome = { url = "github:kdheepak/monochrome.nvim"; flake = false; };
    # lsp
    nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    guihua = { url = "github:ray-x/guihua.lua"; flake = false; };
    lsp-navigator = { url = "github:ray-x/navigator.lua"; flake = false; };
    lspsaga-nvim = { url = "github:tami5/lspsaga.nvim"; flake = false; };
    # git
    octo = { url = "github:pwntester/octo.nvim"; flake = false; };
    vim-diffview = { url = "github:sindrets/diffview.nvim"; flake = false; };
    # dash
    dash-nvim = {
      url = "github:mrjones2014/dash.nvim";
      flake = false;
    };
    # testing
    ultest = { url = "github:rcarriga/vim-ultest"; flake = false; };
    vim-test = { url = "github:vim-test/vim-test"; flake = false; };
    # terminal
    iron-nvim = { url = "github:hkupty/iron.nvim"; flake = false; };
    # neorg
    neorg = { url = "github:nvim-neorg/neorg"; flake = false; };
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
        ./layers/neorg
      ];
      default = (import ./.) modules_paths;
      make-overlay = self: k: v: self.vimUtils.buildVimPluginFrom2Nix {
        pname = k;
        version = v.shortRev;
        src = v;
      };
      nvim-plugins = self: builtins.mapAttrs
        (make-overlay self)
        (builtins.removeAttrs inputs [ "self" "nixpkgs" "flake-utils" "devshell" "neovim" "dash-nvim" ]);
      overlay_ = self: super: {
        spacenix-wrapper = (default { pkgs = super; }).customNeovim;
        vimPlugins = super.vimPlugins // {
          dash-nvim = self.vimUtils.buildVimPluginFrom2Nix {
            pname = "dash-nvim";
            version = inputs.dash-nvim.shortRev;
            src = inputs.dash-nvim;
            buildPhase = "make install";
          };
          nvim-treesitter = super.vimPlugins.nvim-treesitter.overrideAttrs (old: {
            passthru.withPlugins =
              grammarFn: self.vimPlugins.nvim-treesitter.overrideAttrs (_: {
                postPatch =
                  let
                    grammars = self.tree-sitter.withPlugins grammarFn;
                    darwin-patch = ''
                      rm -r parser
                      mkdir parser
                      for f in ${grammars}/*.dylib; do 
                         g=`basename $f`
                         ln -s -- "$f" "parser/''${g%.dylib}.so"
                      done
                    '';
                    other-patch = ''
                      rm -r parser
                      ln -s ${grammars} parser
                    '';
                  in
                  if self.stdenv.isDarwin then darwin-patch else other-patch;
              });
          });
        } // (nvim-plugins self);
      };
      overlays_ = [
        neovim.overlay
        (final: prev: {
          python = prev.python3;
        })
        overlay_
      ];
    in
    {
      overlay_list = overlays_;
    } //
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ devshell.overlay ] ++ overlays_;
        };
        customNeovim = (default { inherit pkgs; }).customNeovim;
        default_config = (default { inherit pkgs; }).default_config;
      in
      rec {
        defaultPackage = customNeovim default_config;
        apps = {
          nvim = flake-utils.lib.mkApp {
            drv = defaultPackage;
            name = "nvim";
          };
        };

        wrapper = customNeovim;
        defaultApp = apps.nvim;

        devShell = pkgs.devshell.mkShell {
          name = "neovim";
          packages = [ defaultPackage ];

          commands = [
            {
              name = "vim";
              command = "${defaultPackage}/bin/nvim \"$@\"";
              help = "alias for neovim with spacenix config";
            }
            {
              name = "vi";
              command = "${defaultPackage}/bin/nvim \"$@\"";
              help = "alias for neovim with spacenix config";
            }
          ];
        };
      }
    );
}
