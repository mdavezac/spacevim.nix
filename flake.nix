{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

  outputs = inputs @ {nixpkgs, ...}: let
    mk-overlays = system: pkgs: [
      (final: previous: {
        nuscripts = inputs.nuscripts;
        pyrefly = previous.rustPlatform.buildRustPackage {
          pname = "pyrefly";
          version = "1.0.0";

          src = previous.fetchFromGitHub {
            owner = "facebook";
            repo = "pyrefly";
            tag = "1.0.0";
            hash = "sha256-S3phcTwZlG9VBHdYzcbsLzj0uqBUDy4Xfy/tlp3AQZg=";
          };

          buildAndTestSubdir = "pyrefly";
          cargoHash = "sha256-OfbPPANsAhrp2MbzDEHGRLWWmUkbMMGKR5B4R6lXdE4=";

          cargoPatches = [
            (previous.writeText "pyrefly-1.0.0-fix-cargo-lock.patch" ''
              diff --git a/Cargo.lock b/Cargo.lock
              index c8c39e9617888199b86fa7c0273c0edebc85df2f..ea5e7b7e633a2de582a7b013a32a6eb6b166e2db 100644
              --- a/Cargo.lock
              +++ b/Cargo.lock
              @@ -2866,6 +2866,7 @@ dependencies = [
               name = "rustversion"
               version = "1.0.22"
               source = "registry+https://github.com/rust-lang/crates.io-index"
              +checksum = "b39cdef0fa800fc44525c84ccb54a029961a8215f9619753635a9c0d2538d46d"

               [[package]]
               name = "ryu"
            '')
          ];

          patches = [
            (previous.writeText "pyrefly-1.0.0-fix-shebang.patch" ''
              diff --git a/pyrefly/lib/test/lsp/lsp_interaction/configuration.rs b/pyrefly/lib/test/lsp/lsp_interaction/configuration.rs
              index edc2db09f..ce33a2774 100644
              --- a/pyrefly/lib/test/lsp/lsp_interaction/configuration.rs
              +++ b/pyrefly/lib/test/lsp/lsp_interaction/configuration.rs
              @@ -56,7 +56,7 @@ fn setup_dummy_interpreter(custom_interpreter_path: &Path) -> PathBuf {
                   // Create a mock Python interpreter script that returns the environment info
                   // This simulates what a real Python interpreter would return when queried with the env script
                   let python_script = format!(
              -        r#"#!/usr/bin/env bash
              +        r#"#!${previous.lib.getExe previous.bash}
               if [[ "$1" == "-c" && "$2" == *"import json, sys"* ]]; then
                   cat << 'EOF'
               {{"python_platform": "linux", "python_version": "3.12.0", "site_package_path": ["{site_packages}"]}}
            '')
          ];

          postPatch = ''
            for crate_root in crates/pyrefly_*/src/lib.rs pyrefly/lib/lib.rs pyrefly/bin/main.rs; do
              if grep -q '#!\[warn(clippy::all)\]' "$crate_root"; then
                substituteInPlace "$crate_root" \
                  --replace '#![warn(clippy::all)]' '#![warn(clippy::all)]
          #![feature(if_let_guard)]'
              fi
            done
          '';

          buildInputs = [previous.rust-jemalloc-sys];
          doCheck = false;
          nativeInstallCheckInputs = [previous.versionCheckHook];
          versionCheckProgramArg = "--version";
          doInstallCheck = true;

          preCheck = ''
            export TMPDIR=$(mktemp -d)
          '';

          RUSTC_BOOTSTRAP = 1;

          meta = {
            description = "Fast type checker and IDE for Python";
            homepage = "https://github.com/facebook/pyrefly";
            license = previous.lib.licenses.mit;
            mainProgram = "pyrefly";
            platforms = previous.lib.platforms.linux ++ previous.lib.platforms.darwin;
          };
        };
      })
    ];
  in {
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
            ./home/helix.nix
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
