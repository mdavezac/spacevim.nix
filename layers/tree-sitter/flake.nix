{
  inputs = {
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
  };
  outputs = inputs @ { self, ... }: rec {
    module = { config, lib, pkgs, ... }:
      let
        languages =
          builtins.attrNames (lib.importJSON "${inputs.nvim-treesitter}/lockfile.json");
        tree-sitter = languages: (import ./tree-sitter.nix) {
          inherit (pkgs) stdenv lib writeTextFile curl git cacert neovim;
          languages = lib.sort (a: b: a < b) languages;
          nvim-treesitter-src = inputs.nvim-treesitter;
        };
      in
      {
        options.nvim = lib.mkOption {
          type = lib.types.submodule {
            options.tree-sitter-languages = lib.mkOption {
              type = lib.types.listOf (lib.types.enum languages);
              description = ''
                List of languages for which to build parsers.

                Only the set of "maintained" languages are supported here.
              '';
              example = [ "nix" "python" "C" ];
              default = [ ];
            };
          };
        };

        config.nvim.tree-sitter-languages = lib.intersectLists config.nvim.languages languages;
        config.nvim.layers.tree-sitter.plugins.start = lib.mkIf
          (
            config.nvim.layers.tree-sitter.enable
            && (builtins.length config.nvim.tree-sitter-languages) > 0
          )
          ((pkgs.flake2vim inputs [ ]) ++ [ (tree-sitter config.nvim.tree-sitter-languages) ]);
        config.nvim.layers.tree-sitter.init.lua = builtins.readFile ./init.lua;
      };
  };
}
    