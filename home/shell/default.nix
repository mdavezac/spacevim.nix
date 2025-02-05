{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./zellij.nix];
  home.packages = [pkgs.glab pkgs.devenv];
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    environmentVariables.SHELL = "nu";
    envFile.source = ./env.nu;
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

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "https";
    settings.prompt = "disabled";
    settings.editor = "nvim";
  };

  programs.git = {
    enable = true;
    aliases.identity = let
      git = "${pkgs.git}/bin/git";
    in ''! ${git} config user.name "''$(${git} config user.''$1.name)" && ${git} config user.email "''$(${git} config user.''$1.email)" && ${git} config user.signingkey "''$(${git} config user.''$1.signingkey)"'';
    ignores = lib.strings.splitString "\n" (builtins.readFile ../../git/gitignore);
    extraConfig = {
      "user \"roke\"" = {
        name = "Mayeul d'Avezac";
        email = "mayeul.davezacdecastera@roke.co.uk";
        signingKey = "1CEC2DC082392DED";
      };
      "user \"gitlab\"" = {
        name = "Mayeul d'Avezac";
        email = "1085775-mdavezac@users.noreply.gitlab.com";
        signingKey = "4BFEEACF1FBF028A";
      };
      "user \"github\"" = {
        name = "Mayeul d'Avezac";
        email = "2745737+mdavezac@users.noreply.github.com";
        signingKey = "4BFEEACF1FBF028A";
      };
      core.autoclrf = true;
      core.commentChar = "\"";
      colore.ui = true;
      apply.whitespace = "nowarn";
      branch. autosetupmerge = true;
      push.default = "upstream";
      pull.rebase = false;
      advice.statusHints = false;
      format.pretty = "format:%C(blue)%ad%Creset %C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an]%Creset";
      init.defaultBranch = "main";
      commit.gpgsign = true;
    };
  };

  programs.gpg = {
    enable = true;
    mutableTrust = true;
    mutableKeys = true;
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

  services.gpg-agent = {
    enable = true;
    enableNushellIntegration = true;
    defaultCacheTtl = 80000;
  };
}
