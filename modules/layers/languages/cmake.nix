{
  config,
  lib,
  pkgs,
  ...
}: let
  enableIf = lib.mkIf config.spacenix.languages.cmake;
in {
  config.spacenix.treesitter-languages = enableIf ["cmake"];
  config.spacenix.lsp-instances.cmake = enableIf {
    cmd = "\"${pkgs.cmake-language-server}/bin/cmake-language-server\"";
  };
  config.spacenix.layers.completion.sources = enableIf {
    cmake = [
      {
        name = "treesitter";
        priority = 2;
        group_index = 2;
      }
      {
        name = "nvim_lsp";
        priority = 2;
        group_index = 2;
      }
      {
        name = "luasnip";
        priority = 100;
        group_index = 3;
      }
    ];
  };
  config.spacenix.format-on-save = enableIf ["CMakeLists.txt" "*.cmake"];
  config.spacenix.dash.cmake = ["cmake"];
}
