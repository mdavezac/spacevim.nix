inputs @ {
  lib,
  lazy-dist,
  ...
}: prev: final: let
  build-plugin = k: v:
    prev.vimUtils.buildVimPluginFrom2Nix {
      pname = k;
      version = v.shortRev;
      src = v;
    };
  filter = x: (!lib.strings.hasSuffix "-nvim" x) && (!lib.strings.hasPrefix "nvim-" x);
  non-plugins = builtins.filter filter (builtins.attrNames inputs);
  plugins = builtins.removeAttrs inputs non-plugins;
in {
  vimPlugins =
    final.vimPlugins
    // (builtins.mapAttrs build-plugin plugins)
    // {
      lazy-dist = prev.vimUtils.buildVimPluginFrom2Nix {
        pname = "lazy-dist";
        version = lazy-dist.shortRev;
        src = lazy-dist;
        buildPhase = ''
          cat  > lua/lazyvim/plugins/core.lua <<EOF
          require("lazyvim.config").init()
          return {
              { "folke/lazy.nvim", pin = true, enable=false, },
              {
                name="LazyVim", dir='${placeholder "out"}', priority = 10000,
                lazy = false, config = true, pin=true
              }
          }
          EOF
        '';
      };
    };
}
