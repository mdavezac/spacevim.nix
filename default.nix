layers: { system ? builtins.currentSystem, pkgs ? (import (import <nixpkgs>) { inherit system; }) }:
let
  layer_modules = builtins.map
    (x: if (builtins.isAttrs x) then (builtins.getAttr system x) else x)
    (builtins.catAttrs "module" (builtins.attrValues layers));
  evalModules_ = configuration: pkgs.lib.evalModules {
    modules = [ ./layers/module.nix { _module.args.pkgs = pkgs; } ]
      ++ layer_modules
      ++ [ configuration ];
  };
  customNeovim_ = configuration:
    let
      module = evalModules_ configuration;
    in
    pkgs.wrapNeovim pkgs.neovim {
      configure = {
        customRC =
          module.config.nvim.init.vim
          + ("\n\nlua <<EOF\n" + module.config.nvim.init.lua + "\nEOF\n\n")
          + module.config.nvim.post.vim
          + ("\n\nlua <<EOF\n" + module.config.nvim.post.lua + "\nEOF");
        packages.spacevimnix = {
          start = pkgs.lib.unique module.config.nvim.plugins.start;
          opt = pkgs.lib.unique module.config.nvim.plugins.opt;
        };
      };
    };
in
{
  evalModules = evalModules_;
  customNeovim = customNeovim_;
  default_config.nvim = {
    languages.python = true;
    languages.nix = true;
    colorscheme = "neon";
  };
}
