{
  inputs = {
    ultest = { url = "github:rcarriga/vim-ultest"; flake = false; };
    vim-test = { url = "github:vim-test/vim-test"; flake = false; };
  };
  outputs = inputs @ { self, ... }: {
    overlay = (self: super: {
      vimPlugins = super.vimPlugins // {
        ultest = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "ultest";
          version = inputs.ultest.shortRev;
          src = inputs.ultest;
        };
        vim-test = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "vim-test";
          version = inputs.vim-test.shortRev;
          src = inputs.vim-test;
        };
      };
    });
    module = { ... }: {
      imports = [ ./options.nix ./keys.nix ./config.nix ];
    };
  };
}
