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
  config.nvim.init = enableIf {
    vim = ''
      autocmd FileType cpp setlocal comments+=b://!
      autocmd FileType cpp setlocal commentstring=//\ %s
    '';
  };
  config.spacenix.dash = enableIf {cpp = ["cpp"];};
}
