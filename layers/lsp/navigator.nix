{config, pkgs, lib, ...} : {
   config.nvim.plugins.start = [ pkgs.vimPlugins.guihua pkgs.vimPlugins.navigator ];
}
