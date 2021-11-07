{
  inputs = {
    nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
  };
  outputs = inputs @ { self, ... }: {
    overlay = (self: super: {
      vimPlugins = super.vimPlugins // {
        nvim-cmp = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-cmp";
          version = inputs.nvim-cmp.shortRev;
          src = inputs.nvim-cmp;
        };
        nvim-lspconfig = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-lspconfig";
          version = inputs.nvim-lspconfig.shortRev;
          src = inputs.nvim-lspconfig;
        };
      };
    });
    module = inputs @ { config, lib, pkgs, ... }: {
      imports = [ ./lsp.nix ./linters.nix ./completion.nix ./keys.nix ];
    };
  };
}
