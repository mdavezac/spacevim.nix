{
  description = "Big Neovim Energy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    lazy-nvim.url = "github:folke/lazy.nvim";
    lazy-nvim.flake = false;
    lazy-dist.url = "github:LazyVim/LazyVim";
    lazy-dist.flake = false;
    iron-nvim.url = "github:hkupty/iron.nvim";
    iron-nvim.flake = false;
    nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    nvim-lspconfig.flake = false;
    neotest-nvim.url = "github:nvim-neotest/neotest";
    neotest-nvim.flake = false;
    neotest-python-nvim.url = "github:nvim-neotest/neotest-python";
    neotest-python-nvim.flake = false;
    flatten-nvim.url = "github:willothy/flatten.nvim";
    flatten-nvim.flake = false;
    nuscripts.url = "github:nushell/nu_scripts";
    nuscripts.flake = false;
    telescope-nvim.url = "github:nvim-telescope/telescope.nvim";
    telescope-nvim.flake = false;
    telescope-fzf-native.url = "github:nvim-telescope/telescope-fzf-native.nvim";
    telescope-fzf-native.flake = false;
    bufferline-nvim.url = "github:akinsho/bufferline.nvim";
    bufferline-nvim.flake = false;
    nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    nvim-cmp.flake = false;
    cmp-buffer-nvim.url = "github:hrsh7th/cmp-buffer";
    cmp-buffer-nvim.flake = false;
    cmp-lsp-nvim.url = "github:hrsh7th/cmp-nvim-lsp";
    cmp-lsp-nvim.flake = false;
    cmp-path-nvim.url = "github:hrsh7th/cmp-path";
    cmp-path-nvim.flake = false;
    cmp-luasnip-nvim.url = "github:saadparwaiz1/cmp_luasnip";
    cmp-luasnip-nvim.flake = false;
    nui-nvim.url = "github:MunifTanjim/nui.nvim";
    nui-nvim.flake = false;
    noice-nvim.url = "github:folke/noice.nvim";
    noice-nvim.flake = false;
    lualine-nvim.url = "github:nvim-lualine/lualine.nvim";
    lualine-nvim.flake = false;
    which-key-nvim.url = "github:folke/which-key.nvim";
    which-key-nvim.flake = false;
    dressing-nvim.url = "github:stevearc/dressing.nvim";
    dressing-nvim.flake = false;
    conform-nvim.url = "github:stevearc/conform.nvim";
    conform-nvim.flake = false;
    trouble-nvim.url = "github:folke/trouble.nvim";
    trouble-nvim.flake = false;
    rustaceanvim.url = "github:mrcjkb/rustaceanvim";
    rustaceanvim.flake = true;
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    devshell,
    rustaceanvim,
    ...
  }: let
    systemized = system: let
      pkgs = let
        vtsls = import ./vtsls/default.nix {inherit pkgs;};
      in
        import nixpkgs {
          inherit system;
          config = {allowUnfree = true;};
          overlays = [
            devshell.overlays.default
            (import ./spacevim/overlays/plugins.nix ({pkgs = pkgs;} // inputs))
            (final: previous: {nuscripts = inputs.nuscripts;})
            (final: previous: {vtsls = vtsls."@vtsls/language-server";})
            rustaceanvim.overlays.default
          ];
        };
    in rec {
      packages.nvim = (import ./spacevim) {inherit pkgs;};
      packages.tmux = (import ./tmux) {inherit pkgs;};
      packages.zellij = (import ./zellij) {inherit pkgs;};
      packages.git = (import ./git) {inherit pkgs;};
      packages.nushell = (import ./nushell) {
        inherit pkgs;
        inherit (packages) nvim git tmux zellij;
      };
      apps = let
        make = name:
          flake-utils.lib.mkApp {
            drv = builtins.getAttr name packages;
            name = name;
          };
      in {
        nvim = make "nvim";
        tmux = make "tmux";
        zellij = make "zellij";
        git = make "git";
        nushell = flake-utils.lib.mkApp {
          drv = packages.nushell;
          name = "nu";
        };
      };

      devShells.default = pkgs.devshell.mkShell {
        name = "neovim";
        imports = [];
      };
    };
  in
    flake-utils.lib.eachDefaultSystem systemized;
}
