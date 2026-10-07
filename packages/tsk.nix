final: previous: {
  tsk = previous.rustPlatform.buildRustPackage rec {
    pname = "tsk";
    version = "0.11.6";

    src = previous.fetchFromGitHub {
      owner = "smarzban";
      repo = "tsk";
      rev = "911c942c024ff584fb3a74219eac847672ccd44a";
      hash = "sha256-ugTKQzDM4aTzgKuQQBfh4RXbX+ajJrMZWr9rPFeFcKk=";
    };

    cargoHash = "sha256-FMCxgtHvra3AYwL0M2s8x5XbYaLXRGRk1oZ8ezq51Js=";

    doCheck = false;

    nativeInstallCheckInputs = [previous.versionCheckHook];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

    meta = {
      description = "Terminal task board for you and your agents";
      homepage = "https://github.com/smarzban/tsk";
      license = previous.lib.licenses.mit;
      mainProgram = "tsk";
      platforms = previous.lib.platforms.linux ++ previous.lib.platforms.darwin;
    };
  };
}
