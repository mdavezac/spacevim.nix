{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    escapeTime = 10;
    # focusEvents = true;
    keyMode = "vi";
    newSession = true;
    shortcut = "b";
    sensibleOnTop = true;
    terminal = "xterm-256color";
    plugins = [
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      set -g status off
    '';
  };
}
