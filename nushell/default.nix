{
  pkgs,
  nvim,
  git,
  tmux,
}:
pkgs.stdenv.mkDerivation {
  name = "nushell";
  nativeBuildInputs = [pkgs.makeWrapper];
  src = ./.;
  buildInputs = [pkgs.nushell pkgs.starship];
  version = pkgs.nushell.version;
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/share/nushell/overlays

    cp ./env.nu ./config.nu $out/share/nushell/
    sed -i -e "s!@carapace@!${pkgs.carapace}/bin/carapace!g" $out/share/nushell/config.nu

    cp ./spaceenv.nu $out/share/nushell/overlays/
    sed -i -e "s!@nvim@!${nvim}!g" $out/share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@git@!${git}!g" $out/share/nushell/overlays/spaceenv.nu
    sed -i -e "s!@tmux@!${tmux}!g" $out/share/nushell/overlays/spaceenv.nu

    starship init nu > $out/share/nushell/overlays/starship.nu
    echo "overlay use $out/share/nushell/overlays/starship.nu" >> $out/share/nushell/config.nu
    echo "overlay use $out/share/nushell/overlays/spaceenv.nu" >> $out/share/nushell/config.nu

    makeWrapper \
      ${pkgs.nushell}/bin/nu \
      $out/bin/nu  \
      --add-flags "--config=$out/share/nushell/config.nu --env-config=$out/share/nushell/env.nu"
  '';
}
