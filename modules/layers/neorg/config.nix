{
  config,
  lib,
  pkgs,
  ...
}: let
  enable = config.spacenix.layers.neorg.enable;
  enableIf = lib.mkIf enable;
  with-completion = config.spacenix.layers.completion.enable;
  with-dirman = (builtins.length config.spacenix.layers.neorg.workspaces) > 0;
  gtd = config.spacenix.layers.neorg.gtd;
in {
  config.nvim.plugins.start = enableIf [pkgs.vimPlugins.neorg];
  config.spacenix.treesitter-languages = enableIf ["norg"];
  config.spacenix.layers.completion.sources = lib.mkIf (with-completion && enable) {
    norg = [
      {
        name = "neorg";
        group_index = 0;
        priority = 0;
      }
    ];
  };
  config.nvim.init = enableIf {
    lua = let
      workspaces = builtins.concatStringsSep ",\n            " (
        builtins.map
        (k: "${k.name} = \"${k.path}\"")
        config.spacenix.layers.neorg.workspaces
      );
      modules = builtins.concatStringsSep ",\n        " (
        [
          "[\"core.defaults\"] = {}"
          "[\"core.norg.concealer\"] = {}"
          "[\"core.keybinds\"] = { config = { default_keybinds = false } }"
        ]
        ++ (
          if with-completion
          then ["[\"core.norg.completion\"] = { config = { engine = \"nvim-cmp\" } }"]
          else []
        )
        ++ (
          if with-dirman
          then ["[\"core.norg.dirman\"] = { config = { workspaces = {${workspaces}} } }"]
          else []
        )
        ++ (
          if gtd != null
          then ["[\"core.gtd.base\"] = { config = { workspace = \"${gtd}\"}}"]
          else []
        )
      );
    in ''
      require('neorg').setup {
          load = {
              ${modules}
          }
      }
    '';
  };
}
