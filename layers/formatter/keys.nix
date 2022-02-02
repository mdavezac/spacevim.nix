{ config, lib, ... }:
let
  enabled_formatters = lib.filterAttrs (k: v: v.enable) config.nvim.formatters;
  enabled =
    config.nvim.layers.formatter.enable
    && ((builtins.length (builtins.attrNames enabled_formatters)) > 0);
in
{
  config.nvim.which-key = lib.mkIf enabled {
    bindings = [
      { key = "<localleader>f"; command = "<cmd>FormatWrite<cr>"; description = "Format"; }
    ];
  };
}
