{
  buildEnv,
  tree-sitter,
  vimPlugins,
  fetchFromGitHub,
  runCommand,
  lib,
}: let
  nu-src = fetchFromGitHub {
    owner = "nushell";
    repo = "tree-sitter-nu";
    rev = "0bb9a602d9bc94b66fab96ce51d46a5a227ab76c";
    hash = "sha256-A5GiOpITOv3H0wytCv6t43buQ8IzxEXrk3gTlOrO0K0=";
  };
  nu-grammar = tree-sitter.buildGrammar {
    language = "nu";
    version = "0.0.0";
    src = nu-src;
    meta.homepage = "https://github.com/nushell/tree-sitter-nu";
  };
  nu-plugin =
    runCommand "nvim-treesitter-grammar-nu" {
      meta =
        {
          platforms = lib.platforms.all;
        }
        // nu-grammar.meta;
    }
    ''
      mkdir -p $out/parser
      ln -s ${nu-grammar}/parser $out/parser/nu.so
      mkdir -p $out/queries/nu
      cp -r ${nu-src}/queries/nu $out/queries/
    '';
in
  buildEnv {
    name = "nvim-treesitter";
    paths = let
      grammars = vimPlugins.nvim-treesitter.withAllGrammars.passthru.dependencies;
    in
      [vimPlugins.nvim-treesitter] ++ grammars ++ [nu-plugin];
  }
