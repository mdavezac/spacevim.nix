{
  imports = [
    ./options.nix
    ./ui
    ./languages
    ./git.nix
  ];
  programs.nixvim = {
    enable = false;
    defaultEditor = true;
    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "blink.compat"
          "nvim-lspconfig"
        ];
      };
      byteCompileLua.enable = true;
      # viAlias = true;
      # vimAlias = true;
      # luaLoader.enable = true;
    };
  };
}
