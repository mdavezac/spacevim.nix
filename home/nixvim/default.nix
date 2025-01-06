{
  imports = [
    ./options.nix
    ./ui
    ./languages
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "nvim-treesitter"
          "blink.compat"
          "blink.cmp"
        ];
      };
      byteCompileLua.enable = false;
      # viAlias = true;
      # vimAlias = true;
      # luaLoader.enable = true;
    };
    globals.mapleader = " ";
  };
}
