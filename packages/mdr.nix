final: previous: {
  mdr = previous.rustPlatform.buildRustPackage rec {
    pname = "mdr";
    version = "0.6.1";

    src = previous.fetchFromGitHub {
      owner = "CleverCloud";
      repo = "mdr";
      rev = "v${version}";
      hash = "sha256-/jnjfcw+CqHMrz+QNDQ+zVbQmFLB1MooUDzq8ADCY5U=";
    };

    cargoHash = "sha256-2V0N3L6f62dmNcXPJSDxHMlK9wWNmDi5GnN4FB7fcRM=";

    nativeInstallCheckInputs = [previous.versionCheckHook];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

    meta = {
      description = "Lightweight Markdown viewer with live reload and multiple rendering backends";
      homepage = "https://github.com/clevercloud/mdr";
      license = previous.lib.licenses.mit;
      mainProgram = "mdr";
      platforms = previous.lib.platforms.linux ++ previous.lib.platforms.darwin;
    };
  };
}
