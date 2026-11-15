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
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
          bind-key -n C-l if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+/)?(g?\\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?|maki)$'" "send-keys C-l" "select-pane -R"
        '';
      }
    ];
    extraConfig =
      ''
        set -g status off
        set -g extended-keys on
        set -g extended-keys-format csi-u
        set -g allow-passthrough all
        set -as terminal-features ",xterm-ghostty:RGB"
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
