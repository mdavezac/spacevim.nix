{
  config,
  lib,
  pkgs,
  ...
}: let
  enableIf = lib.mkIf config.spacenix.languages.cpp;
in {
  config.spacenix.treesitter-languages = enableIf ["cpp"];
  config.spacenix.lsp-instances.clangd = enableIf {
    cmd = "\"${pkgs.clang-tools}/bin/clangd\"";
  };
  config.nvim.plugins.start = let
    conditional = condition: x:
      if condition
      then [x]
      else [];
  in
    enableIf [pkgs.vimPlugins.rust-tools-nvim];
  config.spacenix.layers.completion.sources = enableIf {
    rust = [
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
  config.spacenix.format-on-save = enableIf ["*.cpp" "*.cc" "*.h" "*.hpp"];
  config.spacenix.dash.cpp = ["cpp"];
}
