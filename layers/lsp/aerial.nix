{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.linters);
  with-any-lsp = builtins.any
    (v: v.enable)
    (builtins.attrValues config.nvim.lsp-instances);
  with-internal-lsp = builtins.any
    (v: v.enable && (v.setup_location == "lsp"))
    (builtins.attrValues config.nvim.lsp-instances);
  internal-lsp = lib.filterAttrs
    (k: v: v.enable && (v.setup_location == "lsp"))
    config.nvim.lsp-instances;
  enabled = (
    config.nvim.layers.lsp.enable
    && (with-any-lsp || with-linters)
    && config.nvim.layers.lsp.aerial
  );
in
{
  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.aerial-nvim ];
  config.nvim.init.lua = ''
    require('telescope').load_extension('aerial')
  '';
  config.nvim.which-key = lib.mkIf enabled {
    bindings = [
      {
        key = "<localleader>a";
        command = "<CMD>AerialToggle<CR>";
        description = "symbol-tree";
      }
      {
        key = "<leader>sa";
        command = "<CMD>Telescope aerial<CR>";
        description = "aerial";
      }
    ];
  };
}
