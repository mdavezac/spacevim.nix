{
  programs.nixvim.plugins.rustaceanvim = {
    enable = true;
    lazyLoad.settings.ft = "rust";
    lazyLoad.settings.before.__raw = ''
      function()
        require('lz.n').trigger_load('neotest')
      end
    '';
    lazyLoad.settings.after.__raw = ''
      function()
          require("neotest").setup({ adapters = { require("rustaceanvim.neotest") } })
      end
    '';
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
      settings.rust-analyzer.checkOnSave.command = "clippy";
    };
  };
}
