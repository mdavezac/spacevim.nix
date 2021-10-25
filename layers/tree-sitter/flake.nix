{
  inputs = {
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
  };
  outputs = inputs @ { self, ... }:
    let
      tree-sitter = nixpkgs: languages: (import ./tree-sitter.nix) {
        inherit (nixpkgs) stdenv lib writeTextFile curl git cacert neovim;
        languages = languages;
        nvim-treesitter-src = inputs.nvim-treesitter;
      };
    in
    rec {
      module = { config, lib, pkgs, ... }: {
        options.nvim = lib.mkOption {
          type = lib.types.submodule {
            options.tree-sitter-languages = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = ''
                List of languages for which to build parsers.

                Only the set of "maintained" languages are supported here.
              '';
              example = [ "nix" "python" "C" ];
              default = [ ];
            };
          };
        };

        config.nvim.layers.tree-sitter.plugins.start =
          let
            base-tree-sitter = tree-sitter pkgs config.nvim.tree-sitter-languages;
          in
          lib.mkIf
            (
              config.nvim.layers.tree-sitter.enable
              && (builtins.length config.nvim.tree-sitter-languages) > 0
            )
            ((pkgs.flake2vim inputs [ ]) ++ [ base-tree-sitter ]);
        config.nvim.layers.tree-sitter.init.lua = builtins.readFile ./init.lua;
      };
    };
}
    