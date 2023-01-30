{ pkgs, config, lib, ... }:
let
  command = ''[ -z "''${NVIM:-}" ] && exec nvim $@ || nvim --server $NVIM --remote $@'';
in
{
  imports = [ ./layers ];
  config = {
    commands = builtins.map (x: { inherit command; name = x; help = "Alias to nvim+remote"; }) [ "vim" "vi" ];
    env = [
      { name = "EDITOR"; value = "vi"; }
    ];
  };
}
