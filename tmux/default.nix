{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "tmux";
  nativeBuildInputs = [pkgs.makeWrapper];
  buildInputs = [pkgs.tmux];
  dontUnpack = "true";
  version = pkgs.tmux.version;
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/share/tmux/
    cp ${./tmux.conf} $out/share/tmux/tmux.conf

    makeWrapper ${pkgs.tmux}/bin/tmux $out/bin/tmux  --add-flags "-f $out/share/tmux/tmux.conf"
  '';
}
