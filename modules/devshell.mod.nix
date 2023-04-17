{
  pkgs,
  config,
  lib,
  ...
}: let
  command = ''[ -z "''${NVIM:-}" ] && exec nvim $@ || exec nvim --server $NVIM --remote $@'';
in {
  config = {
    commands = builtins.map (x: {
      inherit command;
      name = x;
      help = "Alias to nvim+remote";
    }) ["vim" "vi"];
    env = [
      {
        name = "EDITOR";
        value = "vi";
      }
    ];
  };
}
