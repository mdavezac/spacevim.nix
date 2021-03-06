{ nvim-treesitter-src, languages, stdenv, lib, writeTextFile, curl, git, cacert, neovim }:
let
  languages-set = lib.sort (a: b: a < b) (lib.unique languages);
  languages-str = builtins.concatStringsSep ", " (builtins.map (x: "\"${x}\"") languages-set);
  languages-vim = builtins.concatStringsSep " " (builtins.map (x: "${x}") languages-set);
  installParsers = writeTextFile {
    name = "install-parsers.lua";
    text = ''
      treesitter = require("nvim-treesitter")
      treesitter.setup()
      require'nvim-treesitter.configs'.setup({
        ensure_installed = {${languages-str}}
      })
      vim.cmd("TSInstallSync ${languages-vim}")
      vim.cmd("q")
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "nvim-treesitter-parsers-" + (builtins.concatStringsSep "-" languages-set);
  version = nvim-treesitter-src.version;
  src = nvim-treesitter-src.src;

  buildInputs = [ neovim curl cacert git ];

  # Should not be setting HOME
  buildPhase = ''
    HOME=./ CC=$CXX nvim -u NONE --headless -c "set runtimepath+=$PWD" -c "luafile ${installParsers}" +q
  '';

  installPhase = ''
    installDir=$out/parser
    mkdir -p $installDir
    cp -a parser/*.so $installDir
  '';

  meta = with lib; {
    description = let
      langs = builtins.concatStringsSep ", " languages-set;
    in "nvim-treesitter with parsers ${langs}";
    homepage = "https://github.com/nvim-treesitter/nvim-treesitter";
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    license = with licenses; [ asl20 ];
  };
}
