{ config, lib, pkgs, ... }:
let
  with-linters = builtins.any
    (v: v.enable)
    (builtins.attrValues config.spacenix.linters);
  with-any-lsp = builtins.any
    (v: v.enable)
    (builtins.attrValues config.spacenix.lsp-instances);
  with-internal-lsp = builtins.any
    (v: v.enable && (v.setup_location == "lsp"))
    (builtins.attrValues config.spacenix.lsp-instances);
  internal-lsp = lib.filterAttrs
    (k: v: v.enable && (v.setup_location == "lsp"))
    config.spacenix.lsp-instances;
  enabled = (
    config.spacenix.layers.lsp.enable
    && (with-any-lsp || with-linters)
    && config.spacenix.layers.lsp.aerial
  );
in
{
  config.nvim.plugins.start = lib.mkIf enabled [ pkgs.vimPlugins.aerial-nvim ];
  config.nvim.init.lua = ''
    require('telescope').load_extension('aerial')
    require("aerial").setup({
      backends = { "treesitter", "lsp", "markdown" },
    })
  '';
  config.spacenix.which-key = lib.mkIf enabled {
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
