{
  inputs = { };
  outputs = { self, ... }: {
    module = { config, lib, pkgs, ... }: {
      imports = [ ./formatter.nix ];

      config.nvim.which-key = lib.mkIf config.nvim.layers.formatter {
        "<localleader>" = {
          mode = "normal";
          keys.f = {
            command = "<cmd>FormatWrite<cr>";
            description = "Format current buffer";
          };
        };
      };
    };
  };
}
