{pkgs, ...}: {
  imports = [./zellij.nix ./git.nix ./tmux.nix ./maki.nix];
  home.packages = [pkgs.pi];

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
    enableNushellIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./atuin.toml);
  };

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
