{ config, lib, pkgs, ... }:
let
  enable = config.nvim.layers.neorg.enable;
  enableIf = lib.mkIf enable;
  with-completion = config.nvim.layers.completion.enable;
  with-dirman = ((builtins.length config.nvim.layers.neorg.workspaces) > 0);
  gtd = config.nvim.layers.neorg.gtd;
in
{
  config.nvim.plugins.start = enableIf [ pkgs.vimPlugins.neorg ];
  config.nvim.treesitter-languages = enableIf [ "norg" ];
  config.nvim.layers.completion.sources = lib.mkIf (with-completion && enable) {
    norg = [{ name = "neorg"; group_index = 0; priority = 0; }];
  };
  config.nvim.init = enableIf {
    lua =
      let
        workspaces = builtins.concatStringsSep ",\n            " (
          builtins.map
            (k: "${k.name} = \"${k.path}\"")
            config.nvim.layers.neorg.workspaces
        );
        modules = builtins.concatStringsSep ",\n        " (
          [
            "[\"core.defaults\"] = {}"
            "[\"core.norg.concealer\"] = {}"
            "[\"core.keybinds\"] = { config = { default_keybinds = false } }"
          ]
          ++ (
            if with-completion then
              [ "[\"core.norg.completion\"] = { config = { engine = \"nvim-cmp\" } }" ]
            else [ ]
          )
          ++ (
            if with-dirman then
              [ "[\"core.norg.dirman\"] = { config = { workspaces = {${workspaces}} } }" ]
            else [ ]
          )
          ++ (
            if gtd != null then
              [ "[\"core.gtd.base\"] = { config = { workspace = \"${gtd}\"}}" ]
            else [ ]
          )
        );
      in
      ''
        require('neorg').setup {
            load = {
                ${modules}
            }
        }
      '';
  };
  config.nvim.post = enableIf {
    vim = ''
      NeorgStart
    '';
  };
}
