{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "nushell";
  nativeBuildInputs = [pkgs.makeWrapper];
  buildInputs = [pkgs.nushell];
  dontUnpack = "true";
  version = pkgs.nushell.version;
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/share/nushell/
    cp ${./env.nu} ${./config.nu} $out/share/nushell/
    sed -i -e "s!@carapace@!${pkgs.carapace}/bin/carapace!g" $out/share/nushell/config.nu

    makeWrapper \
      ${pkgs.nushell}/bin/nu \
      $out/bin/nu  \
      --add-flags "--config $out/share/nushell/config.nu" "--env-config $out/share/nushell/env.nu"
  '';
}
