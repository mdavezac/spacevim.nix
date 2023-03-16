{
  pkgs,
  config,
  lib,
  ...
}: let
  command = ''exec nvim $@'';
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
