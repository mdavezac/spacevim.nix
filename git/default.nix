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

    sed -e "s!@git@!$out/bin/git!g" ${./gitconfig} > $out/share/git/gitconfig
    sed -i -e "s!@out@!$out!g" $out/share/git/gitconfig
    sed -i -e "s!@gh@!${pkgs.gh}/bin/gh!g" $out/share/git/gitconfig

    cp ${./gitignore} $out/share/git/gitignore

    makeWrapper ${pkgs.git}/bin/git $out/bin/git  --set-default GIT_CONFIG_GLOBAL "$out/share/git/gitconfig"
  '';
}
