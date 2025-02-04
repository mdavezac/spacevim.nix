{
  imports = [
    ./options.nix
    ./ui
    ./languages
    ./git.nix
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.useGlobalPackages = true;
    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "blink.compat"
          "nvim-lspconfig"
          "nui.nvim"
          "neotest-python"
        ];
      };
      byteCompileLua.enable = false;
      # viAlias = true;
      # vimAlias = true;
      # luaLoader.enable = true;
    };
    plugins.lz-n.enable = true;
  };
}
