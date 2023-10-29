{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "zellij";
  nativeBuildInputs = [pkgs.makeWrapper];
  buildInputs = [pkgs.zellij];
  dontUnpack = "true";
  version = pkgs.zellij.version;
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/share/zellij/
    cp ${./zellij.kdl} $out/share/zellij/zellij.kdl

    makeWrapper ${pkgs.zellij}/bin/zellij $out/bin/zellij  --add-flags "-c $out/share/zellij/zellij.kdl"
  '';
}
