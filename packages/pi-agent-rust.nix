final: previous: {
  "pi-agent-rust" = previous.stdenv.mkDerivation {
    pname = "pi-agent-rust";
    version = "0.2.0";

    src = previous.fetchFromGitHub {
      owner = "Dicklesworthstone";
      repo = "pi_agent_rust";
      rev = "0bb0fe63ecaa64ee15d0782b148f51add8783b78";
      hash = "sha256-ZKhn6yRr/38Dh95y1xtfNRDB1kR3c83HlGVfdIhwhyw=";
    };

    nativeBuildInputs = [previous.cargo previous.rustc previous.git];
    buildInputs = [previous.sqlite previous.pkg-config];

    # `loom` is only used by the upstream test suite. It is a git dependency,
    # so remove it before Cargo resolves dependencies for the production build.
    postPatch = ''
      sed -i '/^[[:space:]]*loom[[:space:]]*=/d' Cargo.toml
    '';

    CARGO_NET_GIT_FETCH_WITH_CLI = "true";
    SSL_CERT_FILE = "${previous.cacert}/etc/ssl/certs/ca-bundle.crt";
    CARGO_HTTP_CAINFO = "${previous.cacert}/etc/ssl/certs/ca-bundle.crt";
    GIT_SSL_CAINFO = "${previous.cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "${previous.cacert}/etc/ssl/certs/ca-bundle.crt";

    doCheck = false;

    buildPhase = ''
      runHook preBuild
      export HOME="$TMPDIR/home"
      export CARGO_HOME="$TMPDIR/cargo-home"
      mkdir -p "$HOME" "$CARGO_HOME"
      git config --global http.sslCAInfo "$GIT_SSL_CAINFO"
      cargo build --release
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 target/release/pi $out/bin/pi
      runHook postInstall
    '';

    meta = {
      description = "Terminal-based conversational interface for Rust";
      homepage = "https://github.com/Dicklesworthstone/pi_agent_rust";
      license = previous.lib.licenses.mit;
      platforms = previous.lib.platforms.linux ++ previous.lib.platforms.darwin;
      mainProgram = "pi";
    };
  };

  # Keep compatibility with prior package name in home-manager config.
  pi_agent_rust = final."pi-agent-rust";
}
