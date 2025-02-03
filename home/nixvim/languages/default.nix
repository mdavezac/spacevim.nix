{config, ...}: {
  imports = [
    ./nix.nix
    ./lsp-base.nix
    ./conform-base.nix
    ./completion.nix
    ./rust.nix
    ./python.nix
    ./lean.nix
  ];
  programs.nixvim.plugins = {
    treesitter.enable = true;
    treesitter-context.enable = !config.programs.nixvim.plugins.navic.enable;
    navic.enable = true;
    mini.modules.comment = {
      enable = true;
      comment = "gc";
      comment_line = "gcc";
      comment_visual = "gc";
      textobject = "gc";
    };
  };
  programs.nixvim.plugins.neotest = {
    lazyLoad.settings = {
      ft = ["rust" "python"];
      after.__raw = ''
        function()
            require("neotest").setup({ adapters = { require("neotest-python") } })
        end
      '';
      cmd = "Neotest";
      keys = [
        {
          __unkeyed-1 = "<leader>cs";
          __unkeyed-2 = "<CMD>Neotest summary<CR>";
          desc = "Test Summary";
        }
        {
          __unkeyed-1 = "<leader>ct";
          __unkeyed-2.__raw = ''
            function()
                require("neotest").run.run()
            end
          '';
          desc = "Run nearest test";
        }
        {
          __unkeyed-1 = "<leader>cT";
          __unkeyed-2.__raw = ''
            function()
                require("neotest").run.stop()
            end
          '';
          desc = "Stop test";
        }
        {
          __unkeyed-1 = "<leader>cF";
          __unkeyed-2.__raw = ''
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end
          '';
          desc = "Run test file";
        }
      ];
    };
  };
}
