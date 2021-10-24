inputs: { lib, pkgs, config, ... }:
let
  vim-plugin-from-key-value-pair = k: v: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = k;
    version = v.shortRev;
    src = v;
  };
  plugins = builtins.attrValues (
    builtins.mapAttrs
      vim-plugin-from-key-value-pair
      (builtins.removeAttrs inputs [ "self" "nixpkgs" ])
  );
in
{
  config.nvim.layers.base.plugins.start = plugins;
}
