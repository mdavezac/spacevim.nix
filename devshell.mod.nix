wrapped_nvim: { pkgs, config, lib, ... }:
let
  vicmd = ''
    rpc=$PRJ_DATA_DIR/nvim.rpc
    [ -e $rpc ] && ${pkgs.neovim-remote}/bin/nvr --servername $rpc -s $@ || ${wrapped_nvim}/bin/nvim $@
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
  config = {
    devshell.packages = [ wrapped_nvim ];
    commands = builtins.map (x: { name = x; command = vicmd; help = "Alias to nvim+remote"; }) [ "vim" "vi" ];
    env = [
      { name = "EDITOR"; value = builtins.concatStringsSep " " vi_args; }
      { name = "NVIM_LISTEN_ADDRESS"; eval = "$PRJ_DATA_DIR/nvim.rpc"; }
    ];
  };
}
