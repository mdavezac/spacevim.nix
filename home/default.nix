{
  pkgs,
  lib,
  rio-themes,
  ...
}: {
  imports = [
    ./shell
    # ./niri.nix
    ./hyprland.nix
    ./nixvim
    ./stylix.nix
  ];

  # TODO please change the username & home directory to your own
  home.username = "mdavezac";
  home.homeDirectory = "/home/mdavezac";
  home.file.".config/rio/themes" = {
    source = "${rio-themes}/rio";
    recursive = false;
    executable = false;
  };

  # set cursor size and dpi for 4k monitor
  xresources.properties = lib.mkForce {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    wine64
    winetricks
    heroic
    nvitop
    lastpass-cli
  ];
  programs.kitty.enable = false;
  programs.nixvim.clipboard.providers.wl-copy.enable = true;
  programs.nixvim.clipboard.providers.xclip.enable = true;

  programs.firefox = {
    enable = true;
    languagePacks = ["en-US" "en-GB" "fr-FR"];
  };
  stylix.targets.firefox.profileNames = ["default"];

  programs.rio = {
    enable = false;
    settings = {
      editor.program = "nvim";
      editor.args = [];
      theme = "catppuccin-mocha";
      fonts.family = "FiraCode Nerd Font";
      shell.program = "nu";
      shell.args = [];
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = false;
    settings = {
      env.TERM = "xterm-256color";
      shell = "nu";
      font.size = 10;
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
