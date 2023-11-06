inputs @ {
  pkgs,
  lazy-dist,
  ...
}: prev: final: let
  build-plugin = k: v:
    prev.vimUtils.buildVimPlugin {
      pname = k;
      version = v.shortRev;
      src = v;
    };
  filter = x: (!pkgs.lib.strings.hasSuffix "-nvim" x) && (!pkgs.lib.strings.hasPrefix "nvim-" x);
  non-plugins = builtins.filter filter (builtins.attrNames inputs);
  plugins = builtins.removeAttrs inputs non-plugins;
in {
  vimPlugins =
    final.vimPlugins
    // (builtins.mapAttrs build-plugin plugins)
    // {
      lazy-dist = prev.vimUtils.buildVimPlugin {
        pname = "lazy-dist";
        version = lazy-dist.shortRev;
        src = lazy-dist;
        buildPhase = ''
          cat  > lua/lazyvim/plugins/core.lua <<EOF
          require("lazyvim.config").init()
          return {
              { "folke/lazy.nvim", pin = true, enable=false },
              { name="LazyVim", dir = require("config.directories") .. "/LazyVim" }
          }
          EOF
        '';
      };
    };
}
