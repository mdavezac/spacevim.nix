{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "git";
  nativeBuildInputs = [pkgs.makeWrapper];
  buildInputs = [pkgs.git pkgs.gh];
  dontUnpack = "true";
  version = pkgs.git.version;
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/share/git/

    sed -e "s!@git@!$out/bin/git!g" ${./gitconfig} > $out/share/git/config
    sed -i -e "s!@out@!$out!g" $out/share/git/config
    sed -i -e "s!@gh@!${pkgs.gh}/bin/gh!g" $out/share/git/config

    cp ${./gitignore} $out/share/git/ignore

    makeWrapper ${pkgs.git}/bin/git $out/bin/git  --set-default GIT_CONFIG_SYSTEM "$out/share/git/config"
  '';
}
