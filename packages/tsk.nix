final: previous: {
  tsk = previous.rustPlatform.buildRustPackage rec {
    pname = "tsk";
    version = "0.13.0";

    src = previous.fetchFromGitHub {
      owner = "smarzban";
      repo = "tsk";
      rev = "8e7c577dfcfa6f80b9bb9de0365947d7e40d438f";
      hash = "sha256-mfhISX0Ai9dOk9GZPSRFNqvzwAniU8pkGEE4eb5S5i0=";
    };

    cargoHash = "sha256-rIdI7MYi4feTv1tHXxkTq7VoU7cX+jb7hKMN1GjbnUI=";

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
