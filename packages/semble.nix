final: previous: {
  semble = previous.writeShellApplication {
    name = "semble";
    runtimeInputs = [previous.uv];
    text = ''
      exec uvx --from "semble[mcp]==0.5.5" semble "$@"
    '';
    meta = {
      description = "Fast and accurate code search for agents";
      homepage = "https://github.com/MinishLab/semble";
      license = previous.lib.licenses.mit;
      mainProgram = "semble";
      platforms = previous.lib.platforms.linux ++ previous.lib.platforms.darwin;
    };
  };
}
