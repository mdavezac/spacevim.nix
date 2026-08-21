final: previous: {
  pyrefly = let
    src = previous.fetchFromGitHub {
      owner = "facebook";
      repo = "pyrefly";
      tag = "1.2.0";
      hash = "sha256-36MjpYlw53DvLasBIpiGK0MHY3skVazqYwcmLZwXL9E=";
    };
  in previous.rustPlatform.buildRustPackage {
    pname = "pyrefly";
    version = "1.2.0";

    inherit src;

    buildAndTestSubdir = "pyrefly";
    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "backtrace-0.3.76" = "sha256-LQ/lvsn9BKVj8Xhi+5mosvSrswJ+wiuA6FEUtU0Kb90=";
        "lsp-types-0.95.2" = "sha256-+f3XtEm0fSvgl12LVSeGJGnPElGScAufh9dmMOqKnI8=";
      };
    };

    patches = [
      (previous.writeText "pyrefly-1.2.0-fix-shebang.patch" ''
        diff --git a/pyrefly/lib/test/lsp/lsp_interaction/configuration.rs b/pyrefly/lib/test/lsp/lsp_interaction/configuration.rs
        index edc2db09f..ce33a2774 100644
        --- a/pyrefly/lib/test/lsp/lsp_interaction/configuration.rs
        +++ b/pyrefly/lib/test/lsp/lsp_interaction/configuration.rs
        @@ -56,7 +56,7 @@ fn setup_dummy_interpreter(custom_interpreter_path: &Path) -> PathBuf {
             // Create a mock Python interpreter script that returns the environment info
             // This simulates what a real Python interpreter would return when queried with the env script
             let python_script = format!(
        -        r#"#!/usr/bin/env bash
        +        r#"#!${previous.lib.getExe previous.bash}
         if [[ "$1" == "-c" && "$2" == *"import json, sys"* ]]; then
             cat << 'EOF'
         {{"python_platform": "linux", "python_version": "3.12.0", "site_package_path": ["{site_packages}"]}}
      '')
    ];

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
