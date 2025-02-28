{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./zellij.nix ./git.nix];
  home.packages = [pkgs.devenv];
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

  programs.neovim = {
    enable = !config.programs.nixvim.enable;
    defaultEditor = true;
    extraLuaConfig = ''
      require('config.lazyentry').setup()
    '';
    plugins = [((import ../spacevim/dist.nix) pkgs)];
    viAlias = true;
    vimAlias = true;
  };

  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../../nushell/atuin.toml);
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../../nushell/starship.toml);
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
