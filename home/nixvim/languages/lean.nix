{
  programs.nixvim.plugins = {
    lean.enable = true;
    lean.lazyLoad.enable = true;
    lean.lazyLoad.settings.ft = "lean";
  };
}
