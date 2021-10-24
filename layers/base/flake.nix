{
  inputs = {
    which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    plenary = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
  };
  outputs = inputs @ { self, ... }:
    let
      plugin_defs = (import ./plugin_defs.nix) inputs;
    in
    rec {
      module = { config, lib, pkgs, ... }: {
        imports = [ ./module_defs.nix plugin_defs ];
        config.nvim.layers.base.which-key."<leader>f" = {
          name = "+file";
          mode = "normal";
          keys.f = {
            command = "<cmd>Telescope find_files<cr>";
            description = "Find File";
          };
          keys.r = {
            command = "<cmd>Telescope oldfiles<cr>";
            description = "Open Recent File";
          };
          keys.n = {
            command = "<cmd>enew<cr>";
            description = "New File";
          };
        };
      };
    };
}
