{config, ...}: {
  imports = [
    ./nix.nix
    ./lsp-base.nix
    ./conform-base.nix
    ./completion.nix
    ./rust.nix
    ./python.nix
    ./lean.nix
    ./cpp.nix
    ./toml.nix
    ./yaml.nix
    ./markdown.nix
    ./julia.nix
    ./terraform.nix
    ./typescript.nix
    ./rest.nix
    ./json.nix
    ./unison.nix
  ];
  programs.nixvim.plugins = {
    treesitter.enable = true;
    treesitter.settings = {
      highlight.enable = true;
      indent.enable = true;
      incremental_selection = {
        enable = true;
        init_selection = "<C-space>";
        node_incremental = "<C-space>";
        scope_incremental = false;
        node_decremental = "<bs>";
      };
    };
    treesitter-textobjects.enable = true;
    treesitter-textobjects.settings.move = {
      enable = true;
      goto_next_start = {
        "]f" = "@function.outer";
        "]c" = "@class.outer";
        "]a" = "@parameter.inner";
      };
      goto_next_end = {
        "]F" = "@function.outer";
        "]C" = "@class.outer";
        "]A" = "@parameter.inner";
      };
      goto_previous_start = {
        "[f" = "@function.outer";
        "[c" = "@class.outer";
        "[a" = "@parameter.inner";
      };
      goto_previous_end = {
        "[F" = "@function.outer";
        "[C" = "@class.outer";
        "[A" = "@parameter.inner";
      };
    };
    mini.modules.ai = {
      enable = true;
      n_lines = 500;
      custom_textobjects.__raw = ''
        {
            o = require('mini.ai').gen_spec.treesitter({ -- code block
              a = { "@block.outer", "@conditional.outer", "@loop.outer" },
              i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }),
            f = require('mini.ai').gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
            c = require('mini.ai').gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
            t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
            d = { "%f[%d]%d+" }, -- digits
            e = { -- Word with case
              { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
              "^().*()$",
            },
            u = require('mini.ai').gen_spec.function_call(), -- u for "Usage"
            U = require('mini.ai').gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        }
      '';
    };
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
