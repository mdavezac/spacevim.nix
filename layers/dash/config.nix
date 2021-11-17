{ config, lib, pkgs, ... }:
let
  filetypes = lib.filterAttrs (k: v: builtins.length (v) > 0) config.nvim.dash;
  enable = config.nvim.layers.dash.enable
    && ((builtins.length (builtins.attrNames filetypes)) > 0);
in
{
  config.nvim.plugins.start = lib.mkIf enable [ pkgs.vimPlugins.dash-nvim ];
  config.nvim.init.lua =
    let
      line = k: v:
        "libdash_kw[\"${k}\"] = {"
        + (builtins.concatStringsSep ", " (builtins.map (x: "\"${x}\"") v))
        + "}";
      lines = builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs line filetypes));
    in
    lib.mkIf enable (
      ''
        require('telescope').setup({extensions = {dash = {}}})
        local libdash_kw = require('libdash_nvim').config.file_type_keywords
        libdash_kw["dashboard"] = false
        libdash_kw["NvimTree"] = false
        libdash_kw["TelescopePrompt"] = false
        libdash_kw["terminal"] = false
        libdash_kw["packer"] = false
        libdash_kw["fzf"] = false
        libdash_kw["NeogitStatus"] = false
      '' + "\n" + lines
    );

  config.nvim.which-key = lib.mkIf enable {
    "s" = {
      mode = "normal";
      keys.k = {
        command = "<cmd>DashWord<cr>";
        description = "Search dash for word under cursor";
      };
      keys.K = {
        command = "<cmd>Dash<cr>";
        description = "Search dash";
      };
    };
  };
}
