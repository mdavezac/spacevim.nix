{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    blink-nvim.url = "github:Saghen/blink.nvim";
    blink-nvim.inputs.nixpkgs.follows = "nixpkgs";
    blink-compat.url = "github:Saghen/blink.compat";
    blink-compat.flake = false;

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    rio-themes.url = "github:mbadolato/iTerm2-Color-Schemes";
    rio-themes.flake = false;
    devshell.url = "github:numtide/devshell";
    nuscripts.url = "github:nushell/nu_scripts";
    nuscripts.flake = false;

    lazy-nvim.url = "github:folke/lazy.nvim";
    lazy-nvim.flake = false;
    lazy-dist.url = "github:LazyVim/LazyVim";
    lazy-dist.flake = false;
    # iron-nvim.url = "github:hkupty/iron.nvim";
    # iron-nvim.flake = false;
    # nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    # nvim-lspconfig.flake = false;
    # neotest-nvim.url = "github:nvim-neotest/neotest";
    # neotest-nvim.flake = false;
    # neotest-python-nvim.url = "github:nvim-neotest/neotest-python";
    # neotest-python-nvim.flake = false;
    # flatten-nvim.url = "github:willothy/flatten.nvim";
    # flatten-nvim.flake = false;
    # telescope-nvim.url = "github:nvim-telescope/telescope.nvim";
    # telescope-nvim.flake = false;
    # telescope-fzf-native.url = "github:nvim-telescope/telescope-fzf-native.nvim";
    # telescope-fzf-native.flake = false;
    # bufferline-nvim.url = "github:akinsho/bufferline.nvim";
    # bufferline-nvim.flake = false;
    # nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    # nvim-cmp.flake = false;
    # cmp-buffer-nvim.url = "github:hrsh7th/cmp-buffer";
    # cmp-buffer-nvim.flake = false;
    # cmp-lsp-nvim.url = "github:hrsh7th/cmp-nvim-lsp";
    # cmp-lsp-nvim.flake = false;
    # cmp-path-nvim.url = "github:hrsh7th/cmp-path";
    # cmp-path-nvim.flake = false;
    # cmp-luasnip-nvim.url = "github:saadparwaiz1/cmp_luasnip";
    # cmp-luasnip-nvim.flake = false;
    # nui-nvim.url = "github:MunifTanjim/nui.nvim";
    # nui-nvim.flake = false;
    # noice-nvim.url = "github:folke/noice.nvim";
    # noice-nvim.flake = false;
    # lualine-nvim.url = "github:nvim-lualine/lualine.nvim";
    # lualine-nvim.flake = false;
    # which-key-nvim.url = "github:folke/which-key.nvim";
    # which-key-nvim.flake = false;
    # dressing-nvim.url = "github:stevearc/dressing.nvim";
    # dressing-nvim.flake = false;
    # conform-nvim.url = "github:stevearc/conform.nvim";
    # conform-nvim.flake = false;
    # trouble-nvim.url = "github:folke/trouble.nvim";
    # trouble-nvim.flake = false;
    # rustaceanvim.url = "github:mrcjkb/rustaceanvim";
    # rustaceanvim.flake = true;
    # rustaceanvim.inputs.nixpkgs.follows = "nixpkgs";
    # neotest-haskell.url = "github:mrcjkb/neotest-haskell";
    # neotest-haskell.flake = true;
    # neotest-haskell.inputs.nixpkgs.follows = "nixpkgs";
    # haskell-tools.url = "github:mrcjkb/haskell-tools.nvim";
    # haskell-tools.flake = true;
    # haskell-tools.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-utils,
    devshell,
    # rustaceanvim,
    #  neotest-haskell,
    #  haskell-tools,
    ...
  }: let
    mk-overlays = system: pkgs: [
      devshell.overlays.default
      # (import ./spacevim/overlays/plugins.nix ({pkgs = pkgs;} // inputs))
      (final: previous: {nuscripts = inputs.nuscripts;})
      (final: previous: {vtsls = (import ./vtsls/default.nix {inherit pkgs;})."@vtsls/language-server";})
      #  rustaceanvim.overlays.default
      # neotest-haskell.overlays.default
      # haskell-tools.overlays.default
      # (prev: final: {
      # (prev: final: {
      #   heroic = inputs.unstable.legacyPackages.${system}.heroic;
      #   vimPlugins =
      #     final.vimPlugins
      #     // {
      #       inherit
      #         (inputs.unstable.legacyPackages.${system}.vimPlugins)
      #         blink-cmp
      #         blink-compat
      #         lsp-config
      #         ;
      #     };
      # })
    ];
    systemized = system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = mk-overlays system pkgs;
      };
    in rec {
      packages.nvim = (import ./spacevim) {inherit pkgs;};
      packages.tmux = (import ./tmux) {inherit pkgs;};
      packages.zellij = (import ./zellij) {inherit pkgs;};
      packages.git = (import ./git) {inherit pkgs;};
      packages.nushell = (import ./nushell) {
        inherit pkgs;
        inherit (packages) nvim git tmux zellij;
      };
      apps = let
        make = name:
          flake-utils.lib.mkApp {
            drv = builtins.getAttr name packages;
            name = name;
          };
      in {
        nvim = make "nvim";
        tmux = make "tmux";
        zellij = make "zellij";
        git = make "git";
        nushell = flake-utils.lib.mkApp {
          drv = packages.nushell;
          name = "nu";
        };
      };

      devShells.default = pkgs.devshell.mkShell {
        name = "neovim";
        imports = [];
      };
    };
  in
    (flake-utils.lib.eachDefaultSystem systemized)
    // {
      nixosConfigurations.loubakgou = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Import the previous configuration.nix we used,
            # so the old configuration file still takes effect
            inputs.home-manager.nixosModules.home-manager
            inputs.niri.nixosModules.niri
            ./system/configuration.nix
            {
              nix.extraOptions = ''
                trusted-users = root mdavezac
              '';
              programs.nix-ld.enable = true;
              # programs.nix-ld.libraries = [];
              nixpkgs.overlays = mk-overlays system nixpkgs;
              home-manager.useUserPackages = true;

              # TODO replace ryan with your own username
              home-manager.users.mdavezac = {
                imports = [
                  inputs.nixvim.homeManagerModules.nixvim
                  inputs.stylix.homeModules.stylix
                  ./home
                  {
                    home.packages = [
                      pkgs.google-chrome
                      pkgs.dwarf-fortress-packages.dwarf-fortress-full
                    ];
                  }
                ];
              };

              home-manager.backupFileExtension = "hm-backup";
              home-manager.extraSpecialArgs.rio-themes = inputs.rio-themes;
            }
          ];
        };
      homeConfigurations = let
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          inherit system;
          overlays = mk-overlays system nixpkgs;
        };
        modules = [
          inputs.nixvim.homeManagerModules.nixvim
          inputs.stylix.homeModules.stylix
          {
            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
            stylix.targets.gnome.enable = false;
            stylix.targets.gtk.enable = false;
            stylix.targets.kde.enable = false;
            stylix.targets.xfce.enable = false;
            imports = [
              # {services.gpg-agent.pinentryPackage = pkgs.pinentry-curses;}
              ./home/shell
              ./home/nixvim
              ./home/stylix.nix
              ./home/ipython.nix
            ];
          }
        ];
        configuration = name:
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules =
              modules
              ++ [
                {
                  home.username = name;
                  home.homeDirectory = "/Users/${name}";
                }
              ];
          };
      in {
        mac = configuration "mac";
      };
    };
}
