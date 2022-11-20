{ config, lib, pkgs, ... }:
let
  enabled = config.nvim.layers.base.enable;
in
{
  imports = [ ./options.nix ./general_options.nix ./which_key.nix ./keys.nix ];
  config.nvim.plugins.start = lib.mkIf enabled
    [
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.which-key-nvim
      pkgs.vimPlugins.telescope-fzy-native-nvim
      pkgs.vimPlugins.telescope-ui-select-nvim
      pkgs.vimPlugins.nvim-tree-lua
      pkgs.vimPlugins.undotree
    ];
  config.nvim.init.lua =
    let
      theme = (
        if (builtins.isNull config.nvim.telescope-theme)
        then "nill" else "\"${config.nvim.telescope-theme}\""
      );
    in
    lib.mkIf enabled ''
      require('telescope').load_extension('fzy_native')
      require('nvim-tree').setup {}
      require("telescope").setup {
        pickers = {
          find_files = {
              theme = ${theme},
          },
          live_grep = {
              theme = ${theme},
          },
          lsp_references = {
              theme = ${theme},
          },
          lsp_workspace_symbols = {
              theme = ${theme},
          },
          current_buffer_fuzzy_find = {
              theme = ${theme},
          },
          aerial = {
              theme = ${theme},
          },
        }
      }
    '';
}
