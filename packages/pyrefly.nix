final: previous: {
  pyrefly = let
    src = previous.fetchFromGitHub {
      owner = "facebook";
      repo = "pyrefly";
      tag = "1.4.0";
      hash = "sha256-I+EdNCtwfrCXHZ/wRaxtBW75dw2zQu0PB3b0u5GkyxQ=";
    };
  in previous.rustPlatform.buildRustPackage {
    pname = "pyrefly";
    version = "1.4.0";

    inherit src;

    buildAndTestSubdir = "pyrefly";
    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "backtrace-0.3.76" = "sha256-LQ/lvsn9BKVj8Xhi+5mosvSrswJ+wiuA6FEUtU0Kb90=";
      };
    };

    postPatch = ''
        for crate_root in crates/pyrefly_*/src/lib.rs pyrefly/lib/lib.rs pyrefly/bin/main.rs; do
          if grep -q '#!\[warn(clippy::all)\]' "$crate_root"; then
            substituteInPlace "$crate_root" \
              --replace '#![warn(clippy::all)]' '#![warn(clippy::all)]
      #![feature(if_let_guard)]'
          fi
        done
    '';

    buildInputs = [previous.rust-jemalloc-sys];
    doCheck = false;
    nativeInstallCheckInputs = [previous.versionCheckHook];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

    preCheck = ''
      export TMPDIR=$(mktemp -d)
    '';

    RUSTC_BOOTSTRAP = 1;

    meta = {
      description = "Fast type checker and IDE for Python";
      homepage = "https://github.com/facebook/pyrefly";
      license = previous.lib.licenses.mit;
      mainProgram = "pyrefly";
      platforms = previous.lib.platforms.linux ++ previous.lib.platforms.darwin;
    };
  };
}
