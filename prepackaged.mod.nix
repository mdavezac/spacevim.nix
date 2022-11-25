{ wrapper, prepackaged_pkgs }:
let
  evalModules = configuration: prepackaged_pkgs.lib.evalModules {
    modules = [{ _module.args.pkgs = prepackaged_pkgs; } ./layers]
      ++ [ configuration ];
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
    ((import ./layers/options.nix) { root = "nvim"; })
    ((import ./layers/base/options.nix) { root = "nvim"; })
    ((import ./layers/completion/options.nix) { root = "nvim"; })
    ((import ./layers/dash/options.nix) { root = "nvim"; })
    ((import ./layers/debugger/options.nix) { root = "nvim"; })
    ((import ./layers/formatter/options.nix) { root = "nvim"; })
    ((import ./layers/git/options.nix) { root = "nvim"; })
    ((import ./layers/languages/options.nix) { root = "nvim"; })
    ((import ./layers/lsp/options.nix) { root = "nvim"; })
    ((import ./layers/motion/options.nix) { root = "nvim"; })
    ((import ./layers/neorg/options.nix) { root = "nvim"; })
    ((import ./layers/pimp/options.nix) { root = "nvim"; })
    ((import ./layers/terminal/options.nix) { root = "nvim"; })
    ((import ./layers/testing/options.nix) { root = "nvim"; })
    ((import ./layers/tmux/options.nix) { root = "nvim"; })
    ((import ./layers/tree-sitter/options.nix) { root = "nvim"; })
  ];

  config.packages = [
    (customNeovim { config = { nvim = config.nvim; }; })
  ];
}
