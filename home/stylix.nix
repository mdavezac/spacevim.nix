{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    image = let
      winter = {
        url = "https://www.pixelstalk.net/wp-content/uploads/image11/Winter-night-with-stars-shining-above-a-snowy-landscape.jpg";
        sha256 = "sha256-/yTC5bHUbDRKingCsspJJUL4NRdQOuDwnKqcyKqa7GE=";
      };
      _ = {
        url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
        sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
      };
    in
      pkgs.fetchurl winter;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";
    fonts.monospace.name = "Hasklug Nerd Font";
    fonts.monospace.package = pkgs.hasklig;
    fonts.sizes.applications = 9;
    fonts.sizes.desktop = 7;
    fonts.sizes.popups = 8;
    fonts.sizes.terminal = 8;
    opacity.desktop = 0.5;
    opacity.terminal = 0.8;
  };
}
