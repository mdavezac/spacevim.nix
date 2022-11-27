{ config, pkgs, lib, ... }: {

  imports = [
    ./layers
    ({ config, ... }: { config.nvim = { inherit (config.spacenix) init post plugins; }; })
  ];
  config.packages =
    let
      cfg = config.nvim;
      spacevim-nix = pkgs.wrapNeovim pkgs.neovim {
        configure = {
          customRC =
            cfg.init.vim
            + ("\n\nlua <<EOF\n" + cfg.init.lua + "\nEOF\n\n")
            + cfg.post.vim
            + ("\n\nlua <<EOF\n" + cfg.post.lua + "\nEOF");
          packages.spacevimnix = {
            start = lib.unique cfg.plugins.start;
            opt = lib.unique cfg.plugins.opt;
          };
        };
      };
    in
    [ spacevim-nix ];
}
