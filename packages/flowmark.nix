final: previous: {
  flowmark-rs = previous.rustPlatform.buildRustPackage rec {
    pname = "flowmark-rs";
    version = "0.3.1";

    src = previous.fetchFromGitHub {
      owner = "jlevy";
      repo = "flowmark-rs";
      tag = "v${version}";
      hash = "sha256-YGNKJS3AzgwIIhrLzm4MvuXA4TAd4SbiDvcT7zb7ZXI=";
    };

    cargoDeps = previous.stdenvNoCC.mkDerivation {
      name = "${pname}-${version}-vendor";
      inherit src;

      nativeBuildInputs = [
        previous.cacert
        previous.cargo
      ];
      CARGO_HTTP_CAINFO = "${previous.cacert}/etc/ssl/certs/ca-bundle.crt";
      SSL_CERT_FILE = "${previous.cacert}/etc/ssl/certs/ca-bundle.crt";
      outputHash = "sha256-PjoETC7ceobCRkZ5ZPWocVyHBBqRHMYCO4Z0G2FclJ8=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";

      buildPhase = ''
        runHook preBuild

        export CARGO_HOME="$(mktemp -d)"
        mkdir -p "$out/.cargo"
        cargo vendor --locked "$out" > "$out/.cargo/config.toml"
        cp Cargo.lock "$out/Cargo.lock"
        substituteInPlace "$out/.cargo/config.toml" \
          --replace-fail "$out" "@vendor@"

        runHook postBuild
      '';

      dontConfigure = true;
      dontInstall = true;
      dontFixup = true;
    };

    doCheck = false;
    nativeInstallCheckInputs = [previous.versionCheckHook];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

    meta = {
      description = "Markdown auto-formatter for clean diffs and semantic line breaks";
      homepage = "https://github.com/jlevy/flowmark-rs";
      license = previous.lib.licenses.mit;
      mainProgram = "flowmark";
      platforms = previous.lib.platforms.linux ++ previous.lib.platforms.darwin;
    };
  };
}
