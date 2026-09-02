{
  lib,
  pkgs,
  ...
}: {
  imports = [./zellij.nix ./git.nix ./tmux.nix ./maki.nix];
  home.packages = [pkgs.pi pkgs.semble];

  programs.codex = {
    enable = true;
    package = pkgs.codex;
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    environmentVariables.SHELL = "nu";
    envFile.source = ./env.nu;
    shellAliases.vi = "nvim";
    shellAliases.vim = "nvim";
    shellAliases.cat = "bat";
  };

  programs.bat.enable = true;
  programs.ripgrep.enable = true;

  programs.atuin = {
    enable = true;
    enableNushellIntegration = false;
    settings = builtins.fromTOML (builtins.readFile ./atuin.toml);
  };

  programs.nushell.extraConfig = lib.mkOrder 2000 ''
    source ${
      pkgs.runCommand "atuin-nushell-config.nu" {
        nativeBuildInputs = [pkgs.writableTmpDirAsHomeHook];
      } ''
        ${lib.getExe pkgs.atuin} init nu | awk '
          /name: atuin/ {
            count++
            sub("name: atuin", "name: atuin-" count)
          }
          { print }
        ' > "$out"
      ''
    }
  '';

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.fd.enable = true;

  programs.eza = {
    enable = false;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
