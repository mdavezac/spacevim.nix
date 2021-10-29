{
  inputs = { };
  outputs = { self, ... }: {
    module = { config, lib, pkgs, ... }: {
      imports = [ ./formatter.nix ];

      config.nvim.layers.formatter.which-key = {
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
