{
  programs.nixvim.plugins.rustaceanvim = {
    enable = true;
    lazyLoad.settings.ft = "rust";
    settings.server.default_settings.rust-analyzer = {
      cargo = {
        allFeatures = true;
        loadOutDirsFromCheck = true;
        runBuildScripts = true;
      };
      procMacro = {
        enable = true;
        ignored.async-trait = ["async_trait"];
        ignored.napi-derive = ["napi"];
        ignored.async-recursion = ["async_recursion"];
      };
      files .excludeDirs = [".git" ".local" ".direnv" ".cache" "target"];
    };
  };
}
