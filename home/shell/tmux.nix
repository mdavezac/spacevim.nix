{
  pkgs,
  config,
  ...
}: {
  programs.tmux = {
    enable = true;
    escapeTime = 10;
    focusEvents = true;
    keyMode = "vi";
    newSession = false;
    shortcut = "b";
    sensibleOnTop = true;
    mouse = true;
    terminal = "xterm-256color";
    plugins = [pkgs.tmuxPlugins.vim-tmux-navigator];
    extraConfig =
      ''
        set -g status off
      ''
      + (
        if pkgs.system == "aarch64-darwin"
        then ''
          set-option -g default-command "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l nu"
        ''
        else ""
      );
  };
}
