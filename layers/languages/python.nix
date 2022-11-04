{ config, lib, pkgs, ... }:
let
  enableIf = lib.mkIf config.nvim.languages.python;
  with_debugger = config.nvim.layers.debugger.enable && config.nvim.languages.python;
  with_pytest = (
    config.nvim.layers.testing.enable
    && config.nvim.languages.python
    && config.nvim.layers.testing.python == "pytest"
    && config.nvim.layers.debugger.enable
  );
in
{
  config.nvim.lsp-instances.pyright = enableIf {
    cmd = [ "${pkgs.nodePackages.pyright}/bin/pyright-langserver" "--stdio" ];
  };
  config.nvim.treesitter-languages = enableIf [ "python" ];
  config.nvim.plugins.start =
    let
      conditional = condition: x: if condition then [ x ] else [ ];
    in
    enableIf (
      (conditional config.nvim.layers.treesitter.enable pkgs.vimPlugins.nvim-treesitter-pyfold)
      ++ (conditional config.nvim.layers.debugger.enable pkgs.vimPlugins.nvim-dap-python)
    );
  config.nvim.layers.completion.sources = enableIf {
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
    ];
  };
  config.nvim.formatters = enableIf {
    black = {
      exe = "${pkgs.black}/bin/black";
      args = [ "-q" "-" ];
      filetype = "python";
      enable = true;
    };
    isort = {
      exe = "${pkgs.python39Packages.isort}/bin/isort";
      args = [ "-" ];
      filetype = "python";
      enable = true;
    };
  };
  config.nvim.format-on-save = enableIf [ "*.py" ];
  config.nvim.linters = enableIf {
    "diagnostics.flake8" = {
      exe = "${pkgs.python38Packages.flake8}/bin/flake8";
      enable = false;
    };
  };
  config.nvim.dash.python = enableIf [ "python3" ];
  config.nvim.post.lua = enableIf ''
    require('nvim-treesitter.configs').setup {
        pyfold = {
            enable = true,
            -- Sets provided foldtext on window where module is active
            custom_foldtext = true
        }
    }
  '';
  config.nvim.layers.terminal.repl.favored.python = enableIf "require('iron.fts.python').python3";
  config.nvim.init.lua =
    let
      python = pkgs.python.withPackages (p: [ p.debugpy ]);
      conditional = condition: value: if condition then value else "";
    in
    enableIf (
      (conditional config.nvim.layers.debugger.enable ''
        require("dap-python").setup("${python}/bin/python")
      '') + (conditional with_pytest ''
        require('dap-python').test_runner = 'pytest'
      '')
    );
  config.nvim.init.vim = ''
    au FileType python setlocal comments+=b:#:
  '';
  config.nvim.which-key = lib.mkIf with_debugger {
    bindings = [
      { key = "<localleader>dt"; command = "<cmd>lua require('dap-python').test_method()<cr>"; description = "method"; }
    ];
  };
}
