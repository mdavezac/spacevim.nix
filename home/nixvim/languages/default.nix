{
  config,
  pkgs,
  ...
}: let
  jinja2Grammar = pkgs.tree-sitter.buildGrammar {
    language = "jinja2";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "geigerzaehler";
      repo = "tree-sitter-jinja2";
      rev = "7af726f7ac42db3fe798d45ee375078bbef28a41";
      hash = "sha256-6lw38wvrQP/c3z7m40ygXNij60Gh2owx+Ibvfzwa47s=";
    };
    meta.homepage = "https://github.com/geigerzaehler/tree-sitter-jinja2";
  };
  bloblangGrammar = pkgs.tree-sitter.buildGrammar {
    language = "bloblang";
    version = "0-unstable-2025-05-05";
    src = pkgs.fetchFromGitHub {
      owner = "EmilLaursen";
      repo = "tree-sitter-bloblang";
      rev = "5b34098ec446caadcec0bf667bade2b8551ecb21";
      hash = "sha256-0YO9QtJu6cRPz4Winf8Zrkyhf6YAy/4q4g8pAJooQ6Y=";
    };
    meta.homepage = "https://github.com/EmilLaursen/tree-sitter-bloblang";
  };
  vespaGrammar = (pkgs.tree-sitter.buildGrammar {
    language = "vespa";
    version = "0-unstable-2023-01-28";
    src = pkgs.fetchFromGitHub {
      owner = "bartek";
      repo = "tree-sitter-vespa";
      rev = "618c5b1c9b92daac0b7dd0b41c65158437dbeec5";
      hash = "sha256-eaQfvh2JS7hhlyh+13asxMoKlKMsVobuqbhJpDeVBtk=";
    };
    meta.homepage = "https://github.com/bartek/tree-sitter-vespa";
  }).overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        mkdir -p $out/queries/vespa
        mv $out/queries/*.scm $out/queries/vespa/
      '';
  });
in {
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
  # The upstream grammar does not provide highlight queries.  Place this query
  # in Neovim's runtime so it is used for standalone Jinja2 files and fenced
  # Markdown blocks labelled `jinja2`.
  programs.nixvim.filetype.extension = {
    blobl = "bloblang";
    j2 = "jinja2";
    jinja = "jinja2";
    jinja2 = "jinja2";
  };

  programs.nixvim.extraFiles."queries/jinja2/highlights.scm".text = ''
    (comment) @comment
    (string) @string
    (output) @variable
    (custom_tag) @keyword
  '';

  programs.nixvim.plugins = {
    treesitter.enable = true;
    treesitter.grammarPackages = config.programs.nixvim.plugins.treesitter.package.allGrammars ++ [bloblangGrammar jinja2Grammar vespaGrammar];
    treesitter.languageRegister.bloblang = "blobl";
    treesitter.languageRegister.vespa = "sd";
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
