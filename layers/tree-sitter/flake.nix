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
        treesitter-option = lib.mkOption {
          type = lib.types.listOf (lib.types.enum languages);
          description = ''
            List of languages for which to build treesitter parsers.

            Only the set of "maintained" languages are supported here.
          '';
          example = [ "nix" "python" "C" ];
          default = [ ];
        };
        enabled = config.nvim.layers.treesitter.enable && ((builtins.length config.nvim.treesitter-languages) > 0);
      in
      {
        options.nvim = lib.mkOption {
          type = lib.types.submodule {
            options.treesitter-languages = treesitter-option;
            options.layers = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                options.treesitter-languages = treesitter-option;
              });
            };
          };
        };

        config.nvim.treesitter-languages = lib.flatten (
          builtins.attrValues (
            builtins.mapAttrs
              (k: x: x.treesitter-languages)
              (lib.filterAttrs (k: v: v.enable) config.nvim.layers)
          )
        );
        config.nvim.layers.treesitter.plugins.start =
          if enabled then
            ((pkgs.flake2vim inputs [ ]) ++ [ (tree-sitter config.nvim.treesitter-languages) ])
          else [ ];
        config.nvim.layers.treesitter.init.lua =
          if enabled then (builtins.readFile ./init.lua) else "";
        config.nvim.layers.treesitter.post.vim =
          if enabled then ''
            set foldmethod=expr
            set foldlevel=10
            set foldexpr=nvim_treesitter#foldexpr()
          '' else "";
      };
  };
}
    