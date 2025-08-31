{
  programs.nixvim.plugins.rest = {
    enable = true;
    autoLoad = false;
    settings.request.skip_ssl_verification = true;
    settings.response.hooks.format = true;
    lazyLoad.settings.ft = ["http" "rest"];
  };
}
