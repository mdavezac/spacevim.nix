{ config, lib, pkgs, ... }:
let
  enableIf = lib.mkIf config.nvim.layers.neorg.enable;
  with-completion = config.nvim.layers.completion.enable;
  with-dirman = ((builtins.length config.nvim.layers.neorg.workspaces) > 0);
  gtd = config.nvim.layers.neorg.gtd;
in
{
  config.nvim.plugins.start = enableIf [ pkgs.vimPlugins.neorg ];
  config.nvim.treesitter-languages = enableIf [ "norg" ];
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
        completion_setup =
          if with-completion then ''
            function completion_neorg_setup()
                require('cmp').setup.buffer({
                    sources = {
                        { name = 'neorg' },
                        { name = 'buffer' },
                        { name = 'emoji' },
                        { name = 'path' }
                    }
                })
            end
            vim.api.nvim_exec([[autocmd FileType norg :lua completion_neorg_setup()]], false)
          '' else "";
      in
      ''
        require('neorg').setup {
            load = {
                ${modules}
            }
        }
        ${completion_setup}
      '';
  };
  config.nvim.post = enableIf {
    vim = ''
      NeorgStart
    '';
  };
}
