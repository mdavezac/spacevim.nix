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
          "nui.nvim"
        ];
      };
      byteCompileLua.enable = false;
      # viAlias = true;
      # vimAlias = true;
      # luaLoader.enable = true;
    };
  };
}
