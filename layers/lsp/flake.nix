{
  inputs = {
    nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    guihua = { url = "github:ray-x/guihua.lua"; flake = false; };
    lsp-navigator = { url = "github:ray-x/navigator.lua"; flake = false; };
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
        guihua = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "guihua";
          version = inputs.guihua.shortRev;
          src = inputs.guihua;
          buildPhase = "cd lua/fzy && make && cd ../../";
        };
        lsp-navigator = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "lsp-navigator";
          version = inputs.lsp-navigator.shortRev;
          src = inputs.lsp-navigator;
        };
      };
    });
    module = inputs @ { config, lib, pkgs, ... }: {
      imports = [ ./lsp.nix ./linters.nix ./completion.nix ./keys.nix ./navigator.nix ];
    };
  };
}
