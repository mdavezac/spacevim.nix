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

    unison-lang = {
      url = "github:ceedubs/unison-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-utils,
    devshell,
    ...
  }: let
    mk-overlays = system: pkgs: [
      devshell.overlays.default
      (final: previous: {nuscripts = inputs.nuscripts;})
      (final: previous: {vtsls = (import ./vtsls/default.nix {inherit pkgs;})."@vtsls/language-server";})
      inputs.unison-lang.overlays.default
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
                  inputs.nixvim.homeModules.nixvim
                  inputs.stylix.homeModules.stylix
                  ./home
                  {
                    home.packages = [
                      pkgs.google-chrome
                      pkgs.dwarf-fortress-packages.dwarf-fortress-full
                    ];
                    stylix.targets.ghostty.enable = true;
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
          inputs.nixvim.homeModules.nixvim
          inputs.stylix.homeModules.stylix
          {
            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
            stylix.targets.gnome.enable = false;
            stylix.targets.gtk.enable = false;
            stylix.targets.kde.enable = false;
            stylix.targets.xfce.enable = false;
            imports = [
              # {services.gpg-agent.pinentryPackage = s.defaultpkgs.pinentry-curses;}
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
