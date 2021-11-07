{ config, lib, pkgs, ... }:
let
  tree-sitter = languages: (import ./tree-sitter.nix) {
    inherit (pkgs) stdenv lib writeTextFile curl git cacert neovim;
    languages = lib.sort (a: b: a < b) languages;
    nvim-treesitter-src = pkgs.vimPlugins.nvim-treesitter;
  };
  enabled =
    config.nvim.layers.treesitter.enable
    && ((builtins.length config.nvim.treesitter-languages) > 0);
in
{
  config.nvim.plugins.start = lib.mkIf enabled
    [ pkgs.vimPlugins.nvim-treesitter (tree-sitter config.nvim.treesitter-languages) ];
  config.nvim.init.lua = lib.mkIf enabled
    ''
      require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
      }
    '';
  config.nvim.post.vim = lib.mkIf enabled
    ''
      " Tree-sitter layer
      set foldmethod=expr
      set foldlevel=10
      set foldexpr=nvim_treesitter#foldexpr()
      " End of tree-sitter layer
    '';
}
