{ wrapper, prepackaged_pkgs }:
let
  evalModules = configuration: prepackaged_pkgs.lib.evalModules {
    modules = [
      { _module.args.pkgs = prepackaged_pkgs; }
      ({ config, ... }: { config.nvim = { inherit (config.spacenix) init post plugins; }; })
      ./layers
      configuration
    ];
  };
  customNeovim = configuration:
    let
      nvim = (evalModules configuration).config.nvim;
    in
    prepackaged_pkgs.wrapNeovim prepackaged_pkgs.neovim {
      configure = {
        customRC =
          nvim.init.vim
          + ("\n\nlua <<EOF\n" + nvim.init.lua + "\nEOF\n\n")
          + nvim.post.vim
          + ("\n\nlua <<EOF\n" + nvim.post.lua + "\nEOF");
        packages.spacevimnix = {
          start = prepackaged_pkgs.lib.unique nvim.plugins.start;
          opt = prepackaged_pkgs.lib.unique nvim.plugins.opt;
        };
      };
    };
in
{ config, ... }: {
  imports = [
    ./layers/options.spacevim.nix
    ./layers/base/options.nix
    ./layers/completion/options.nix
    ./layers/dash/options.nix
    ./layers/debugger/options.nix
    ./layers/formatter/options.nix
    ./layers/git/options.nix
    ./layers/languages/options.nix
    ./layers/lsp/options.nix
    ./layers/motion/options.nix
    ./layers/neorg/options.nix
    ./layers/pimp/options.nix
    ./layers/terminal/options.nix
    ./layers/testing/options.nix
    ./layers/tmux/options.nix
    ./layers/tree-sitter/options.nix
  ];

  config.packages = [
    (customNeovim { config = { inherit (config) spacenix; }; })
  ];

}
