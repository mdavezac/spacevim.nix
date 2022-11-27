{ lib, ... }:
let
  plugins_opt = lib.mkOption {
    type = lib.types.submodule {
      options.start = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = "Neovim plugins that are automatically started";
      };
      options.opt = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = "Neovim plugins that are NOT automatically started";
      };
    };
    default = { };
  };

  init_opt = lib.mkOption {
    type = lib.types.submodule {
      options.vim = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Vimscript settings for this layer";
      };
      options.lua = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Lua settings for this layer";
      };
    };
    default = { };
  };
in
{
  options.nvim = lib.mkOption {
    type = lib.types.submodule {
      options.plugins = plugins_opt;
      options.init = init_opt;
      options.post = init_opt;
    };
  };
}
