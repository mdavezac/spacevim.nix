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
  };
}
