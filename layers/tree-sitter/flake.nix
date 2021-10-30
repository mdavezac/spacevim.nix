{
  inputs = { };
  outputs = inputs @ { self, ... }: rec {
    module = { config, lib, pkgs, ... }:
      let
        languages =
          builtins.attrNames (lib.importJSON "${pkgs.vimPlugins.nvim-treesitter.src}/lockfile.json");
        tree-sitter = languages: (import ./tree-sitter.nix) {
          inherit (pkgs) stdenv lib writeTextFile curl git cacert neovim;
          languages = lib.sort (a: b: a < b) languages;
          nvim-treesitter-src = pkgs.vimPlugins.nvim-treesitter;
        };
        treesitter-option = lib.mkOption {
          type = lib.types.listOf (lib.types.enum languages);
          description = ''
            List of languages for which to build treesitter parsers.

            Only the set of "maintained" languages are supported here.
          '';
          example = [ "nix" "python" "C" ];
          default = [ ];
        };
        enabled = config.nvim.layers.treesitter && ((builtins.length config.nvim.treesitter-languages) > 0);
      in
      {
        options.nvim = lib.mkOption {
          type = lib.types.submodule {
            options.treesitter-languages = treesitter-option;
          };
        };

        config.nvim.plugins.start = lib.mkIf enabled
          [ pkgs.vimPlugins.nvim-treesitter (tree-sitter config.nvim.treesitter-languages) ];
        config.nvim.init.lua = lib.mkIf enabled (builtins.readFile ./init.lua);
        config.nvim.post.vim = lib.mkIf enabled
          ''
            " Tree-sitter layer
            set foldmethod=expr
            set foldlevel=10
            set foldexpr=nvim_treesitter#foldexpr()
            " End of tree-sitter layer
          '';
      };
  };
}
    