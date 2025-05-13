{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.glab];
  programs.lazygit.enable = true;
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "https";
    settings.prompt = "disabled";
    settings.editor = "nvim";
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    aliases.identity = let
      git = "${pkgs.git}/bin/git";
    in ''! ${git} config user.name "''$(${git} config user.''$1.name)" && ${git} config user.email "''$(${git} config user.''$1.email)" && ${git} config user.signingkey "''$(${git} config user.''$1.signingkey)"'';
    ignores = lib.strings.splitString "\n" (builtins.readFile ../../git/gitignore);
    extraConfig = {
      "user \"catapult\"" = {
        name = "Mayeul d'Avezac";
        email = "2745737+mdavezac@users.noreply.github.com";
        signingKey = "10658C2507D3A954";
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
      advice.statusHints = false;
      apply.whitespace = "nowarn";
      branch.autosetupmerge = true;
      branch.sort = "committerdate";
      column.ui = "auto";
      commit.gpgsign = true;
      color.ui = true;
      core.autoclrf = true;
      core.commentChar = "\"";
      diff.colorMoved = true;
      diff.algorithm = "histogram";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      fetch.all = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      format.pretty = "format:%C(blue)%ad%Creset %C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an]%Creset";
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      push.default = "upstream";
      push.autoSetupRemote = true;
      pull.rebase = true;
      "credential \"https://dev-git1.dev.local\"".helper = "${pkgs.glab}/bin/glab auth git-credential";
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
      rerere.autoupdate = true;
      rerere.enabled = true;
      tag.sort = "version:refname";
    };
  };
  programs.gpg = {
    enable = true;
    mutableTrust = true;
    mutableKeys = true;
    settings = lib.mkIf (pkgs.system != "aarch64-darwin") {
      pinentry-mode = "loopback";
    };
  };
  services.gpg-agent = {
    enable = pkgs.system != "aarch64-darwin";
    enableNushellIntegration = true;
    defaultCacheTtl = 1000000;
    maxCacheTtl = 1000000;
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}
