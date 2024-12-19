{pkgs}:
pkgs.wrapNeovim pkgs.neovim-unwrapped {
  configure = {
    customRC = ''
      lua require('config.lazyentry').setup()
    '';
    packages.lazy = {
      start = [
        ((import ./dist.nix) pkgs)
      ];
    };
  };
}
