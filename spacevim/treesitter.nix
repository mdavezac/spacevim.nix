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
    rev = "8198386ac0f87067fd1b95e0ec2710a80bf808f2";
    hash = "sha256-uc20yioP2qHzLNiqsmX5XUKQdOknrjSpWOL2tmcqmLs=";
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
      cp ${nu-src}/queries/highlights.scm $out/queries/nu/highlights.scm
    '';
in
  buildEnv {
    name = "nvim-treesitter";
    paths = let
      grammars = vimPlugins.nvim-treesitter.withAllGrammars.passthru.dependencies;
    in
      [vimPlugins.nvim-treesitter] ++ grammars;
  }
