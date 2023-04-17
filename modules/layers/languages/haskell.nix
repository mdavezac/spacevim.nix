{
  config,
  lib,
  pkgs,
  ...
}: let
  enableIf = lib.mkIf config.spacenix.languages.haskell;
in {
  config.nvim.plugins.start = enableIf [pkgs.vimPlugins.haskell-tools-nvim];
  config.spacenix.treesitter-languages = enableIf ["haskell"];
  config.spacenix.dash.haskell = enableIf ["haskell"];
  config.spacenix.layers.terminal.repl.repls = enableIf {
    haskell = ''
      {
         command = function(meta)
           local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
           -- call `require` in case iron is set up before haskell-tools
           return require('haskell-tools').repl.mk_repl_cmd(file)
         end,
      }
    '';
  };
}
