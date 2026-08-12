{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    escapeTime = 10;
    focusEvents = true;
    keyMode = "vi";
    newSession = false;
    shortcut = "b";
    sensibleOnTop = true;
    mouse = true;
    terminal = "tmux-256color";
    historyLimit = 10000;
    plugins = [pkgs.tmuxPlugins.vim-tmux-navigator];
    extraConfig =
      ''
        set -g status off
        set -g extended-keys on
        set -g extended-keys-format csi-u
      ''
      + (
        if pkgs.stdenv.hostPlatform.isDarwin
        then ''
          set-option -g default-command "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l nu"
        ''
        else ""
      );
  };
}
