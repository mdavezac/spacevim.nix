{ pkgs, config, lib, ... }:
let
  vicmd = ''
    if [ -e "$NVIM_LISTEN_ADDRESS" ] && [ ! -z "$NVIM_LISTEN_ADDRESS" ]; then
       ${pkgs.neovim-remote}/bin/nvr --servername $NVIM_LISTEN_ADDRESS -s $@
    else
       echo "Start an nvim process first"
       exit 1
    fi
  '';
  vi_args = [
    "${pkgs.neovim-remote}/bin/nvr"
    "--servername"
    "$PRJ_DATA_DIR/nvim.rpc"
    "-cc split"
    "--remote-wait"
    "-s"
    "$@"
  ];
in
{
  imports = [ ./layers ];
  config = {
    commands = builtins.map (x: { name = x; command = vicmd; help = "Alias to nvim+remote"; }) [ "vim" "vi" ];
    env = [
      { name = "EDITOR"; value = builtins.concatStringsSep " " vi_args; }
      { name = "NVIM_LISTEN_ADDRESS"; eval = "$PRJ_DATA_DIR/nvim.rpc"; }
    ];
  };
}
