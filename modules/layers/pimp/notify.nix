{ config, lib, pkgs, ... }:
let
  cfg = config.spacenix.layers.pimp;
  enable = cfg.enable && cfg.notify;
  with_telescope = enable && config.spacenix.layers.base.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enable [ pkgs.vimPlugins.nvim-notify ];
  config.nvim.post = lib.mkIf enable {

    lua = ''
      require('notify').setup()
      vim.notify = require("notify")
    '' + (
      if with_telescope then
        "\nrequire('telescope').load_extension('notify')\n"
      else ""
    );
  };
  config.spacenix.which-key = lib.mkIf with_telescope {
    bindings = [
      {
        key = "<leader>sn";
        command = "<cmd>Telescope notify<cr>";
        description = "Notifications";
      }
    ];
  };
}
