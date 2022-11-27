{ config, lib, pkgs, ... }:
let
  testing = config.spacenix.layers.testing;
  conditions = (import ./utils.nix) config;
in
{
  config.nvim.plugins.start = lib.mkIf conditions.is_enabled [
    pkgs.vimPlugins.neotest
    pkgs.vimPlugins.neotest-vim-test
    pkgs.vimPlugins.FixCursorHold-nvim
    (lib.mkIf config.spacenix.languages.python pkgs.vimPlugins.neotest-python)
  ];

  config.nvim.init.lua =
    let
      add_if = condition: value: (if condition then [ value ] else [ ]);
      adapters = (add_if conditions.is_python_enabled ''require("neotest-python")'')
        ++ (add_if conditions.is_others_enabled
        ''require("neotest-vim-test")({
          allow_file_types = { ${builtins.concatStringsSep ", " testing.others} },
        })'');
    in
    lib.mkIf conditions.is_enabled ''
      require("neotest").setup({
        adapters = {
          ${builtins.concatStringsSep ",\n    " adapters}
        },
      })
    '';
}
