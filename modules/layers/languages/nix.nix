{ config, lib, pkgs, ... }:
let
  enableIf = lib.mkIf config.spacenix.languages.nix;
in
{
  config.spacenix.lsp-instances.rnix = enableIf {
    cmd = [ "${pkgs.rnix-lsp}/bin/rnix-lsp" ];
  };
  config.spacenix.treesitter-languages = enableIf [ "nix" ];
  config.spacenix.format-on-save = enableIf [ "*.nix" ];
  config.spacenix.layers.completion.sources = enableIf {
    nix = [
      {
        name = "treesitter";
        priority = 2;
        group_index = 2;
      }
      {
        name = "nvim_lsp";
        priority = 2;
        group_index = 2;
      }
    ];
  };
}
