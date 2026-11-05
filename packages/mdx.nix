final: previous: {
  mdx = previous.rustPlatform.buildRustPackage rec {
    pname = "mdx";
    version = "0.1.7";

    src = previous.fetchFromGitHub {
      owner = "gowcar";
      repo = "mdx";
      rev = "v${version}";
      hash = "sha256-TW2VWNj1bBz8ms7LACA6MAL1HGsuQ6mNypglg7oAs5E=";
    };

    cargoHash = "sha256-0nJeSq+GoAucaRmhuiXePVtKpYI+7lJJjvbNlt88CPA=";

    nativeInstallCheckInputs = [previous.versionCheckHook];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

    meta = {
      description = "Fast, beautiful terminal markdown viewer";
      homepage = "https://github.com/gowcar/mdx";
      license = previous.lib.licenses.mit;
      mainProgram = "mdx";
      platforms = previous.lib.platforms.linux ++ previous.lib.platforms.darwin;
    };
  };
}
