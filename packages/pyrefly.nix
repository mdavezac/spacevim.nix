final: previous: {
  pyrefly = let
    src = previous.fetchFromGitHub {
      owner = "facebook";
      repo = "pyrefly";
      tag = "1.1.0";
      hash = "sha256-8bFg8rcUgPsDDflScQWPxDNrEGM5BufjHLPz3Rm0Ur4=";
    };
  in previous.rustPlatform.buildRustPackage {
    pname = "pyrefly";
    version = "1.1.0";

    inherit src;

    buildAndTestSubdir = "pyrefly";
    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "backtrace-0.3.76" = "sha256-LQ/lvsn9BKVj8Xhi+5mosvSrswJ+wiuA6FEUtU0Kb90=";
        "lsp-types-0.95.1" = "sha256-2F43Qa6mXhpCF97cWoi1R0PDgutkEypbyDGtHZerpxM=";
        "ruff_annotate_snippets-0.1.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "ruff_cache-0.0.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "ruff_diagnostics-0.0.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "ruff_notebook-0.0.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "ruff_python_ast-0.0.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "ruff_python_parser-0.0.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "ruff_python_trivia-0.0.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "ruff_source_file-0.0.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "ruff_text_size-0.0.0" = "sha256-WpjOOCYLZ1d8XPUx3qNHD+fuK6t65u/1/ZezABWpBD0=";
        "rustversion-1.0.22" = "sha256-v/K6MMOMqar9DD0NdHR+cqhUOIFtasOn9i3lbxa6xII=";
      };
    };

    patches = [
      (previous.writeText "pyrefly-1.1.0-fix-shebang.patch" ''
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
