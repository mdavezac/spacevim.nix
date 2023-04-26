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
  non-plugins = builtins.filter (x: (!lib.strings.hasSuffix "-nvim" x)) (builtins.attrNames inputs);
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
              { "folke/lazy.nvim", version = "*", enable=false, },
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