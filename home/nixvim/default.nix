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
          "conform.nvim"
          "codecompanion.nvim"
          "nvim-lspconfig"
          "nui.nvim"
          "neotest-python"
          "avante.nvim"
          "snacks.nvim"
          "sidekick.nvim"
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
