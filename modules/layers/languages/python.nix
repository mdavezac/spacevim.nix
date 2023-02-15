{
  config,
  lib,
  pkgs,
  ...
}: let
  enableIf = lib.mkIf config.spacenix.languages.python;
  with_debugger = config.spacenix.layers.debugger.enable && config.spacenix.languages.python;
  with_pytest = (
    config.spacenix.layers.testing.enable
    && config.spacenix.languages.python
    && config.spacenix.layers.testing.python == "pytest"
    && config.spacenix.layers.debugger.enable
  );
in {
  config.spacenix.lsp-instances.pyright = enableIf {
    cmd = "\"${pkgs.nodePackages.pyright}/bin/pyright-langserver\", \"--stdio\"";
  };
  config.spacenix.treesitter-languages = enableIf ["python"];
  config.nvim.plugins.start = let
    conditional = condition: x:
      if condition
      then [x]
      else [];
  in
    enableIf (
      (conditional config.spacenix.layers.treesitter.enable pkgs.vimPlugins.nvim-treesitter-pyfold)
      ++ (conditional config.spacenix.layers.debugger.enable pkgs.vimPlugins.nvim-dap-python)
    );
  config.spacenix.layers.completion.sources = enableIf {
    python = [
      {
        name = "treesitter";
        priority = 2;
        group_index = 2;
      }
      {
        name = "nvim_lsp";
        priority = 2;
        group_index = 2;
      }
      {
        name = "luasnip";
        priority = 100;
        group_index = 3;
      }
    ];
  };
  config.spacenix.format-on-save = enableIf ["*.py"];
  config.spacenix.linters = enableIf {
    "diagnostics.flake8" = {
      exe = "${pkgs.python38Packages.flake8}/bin/flake8";
      enable = false;
    };
  };
  config.spacenix.dash.python = enableIf ["python3"];
  config.nvim.post.lua = enableIf ''
    require('nvim-treesitter.configs').setup {
        pyfold = {
            enable = true,
            -- Sets provided foldtext on window where module is active
            custom_foldtext = true
        }
    }
  '';
  config.spacenix.layers.terminal.repl._default_repls.python =
    enableIf "require('iron.fts.python').python3";
  config.nvim.init.lua = let
    python = pkgs.python.withPackages (p: [p.debugpy]);
    conditional = condition: value:
      if condition
      then value
      else "";
  in
    enableIf (
      (conditional config.spacenix.layers.debugger.enable ''
        require("dap-python").setup("${python}/bin/python")
      '')
      + (conditional with_pytest ''
        require('dap-python').test_runner = 'pytest'
      '')
    );
  config.nvim.init.vim = ''
    au FileType python setlocal comments+=b:#:
  '';
  config.spacenix.which-key = lib.mkIf with_debugger {
    bindings = [
      {
        key = "<localleader>dt";
        command = "<cmd>lua require('dap-python').test_method()<cr>";
        description = "method";
      }
    ];
  };
}
