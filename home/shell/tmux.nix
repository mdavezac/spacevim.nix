{
  pkgs,
  config,
  ...
}: {
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
    extraConfig = let
      shell =
        if pkgs.system == "aarch64-darwin"
        then "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l nu"
        else "${config.home.homeDirectory}/.nix-profile/bin/nu";
    in ''
      set -g status off
      set-option -g default-command "${shell}"
    '';
  };
}
