layers: { system ? builtins.currentSystem, pkgs ? (import (import <nixpkgs>) { inherit system; }) }:
let
  layer_modules = builtins.map
    (x: if (builtins.isAttrs x) then (builtins.getAttr system x) else x)
    (builtins.catAttrs "module" (builtins.attrValues layers));
  tools = {
    mkLayer = { name, options ? { }, default ? true }: {
      options.nvim = pkgs.lib.mkOption {
        type = pkgs.lib.types.submodule {
          options.layers = pkgs.lib.mkOption {
            type = pkgs.lib.types.submodule {
              options."${name}" = pkgs.lib.mkOption {
                type = pkgs.lib.types pkgs.lib.types.submodule {
                  options = {
                    enable = pkgs.lib.mkOption {
                      type = pkgs.lib.types.bool;
                      description = "Whether to use the ${name} layer";
                      default = default;
                    };
                  } // options;
                };
              };
            };
          };
        };
      };
    };
    enabled = name: config:
      let
        split-name = pkgs.lib.splitString name ".";
        is_enabled = config: name:
          if !(builtins.hasAttr name config) then false
          else if !(builtins.hasAttr "enable" (builtins.getAttr name config)) then abort "Missing enable"
          else (builtins.getAttr "enable" (builtins.getattr name config));
        is_enabled_rec = config: names:
          let
            head = builtins.head names;
            rest = builtins.tail names;
          in
          if !(is_enabled config head) then false
          else if ((builtins.length rest) == 0) then true
          else (is_enabled_rec (builtins.getAttr head config) (builtins.head rest) (builtins.tail rest));
      in
      is_enabled_rec config.nvim.layers split-name;
  };
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
          opt = [ ];
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
