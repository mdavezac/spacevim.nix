{ config, pkgs, lib, ... }: {

  imports = [ ./layers ];
  config.packages =
    let
      spacevim-nix = pkgs.wrapNeovim pkgs.neovim {
        configure = {
          customRC =
            config.nvim.init.vim
            + ("\n\nlua <<EOF\n" + config.nvim.init.lua + "\nEOF\n\n")
            + config.nvim.post.vim
            + ("\n\nlua <<EOF\n" + config.nvim.post.lua + "\nEOF");
          packages.spacevimnix = {
            start = lib.unique config.nvim.plugins.start;
            opt = lib.unique config.nvim.plugins.opt;
          };
        };
      };
    in
    [ spacevim-nix ];
}
