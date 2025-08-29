{
  programs.nixvim.plugins.kulala = {
    enable = true;
    autoLoad = false;
    settings.global_keymaps = true;
    lazyLoad.settings.ft = ["http" "rest"];
  };
}
