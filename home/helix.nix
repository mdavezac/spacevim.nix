{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
      };
    };
    languages = {
      language-server = {
        nil-lsp.command = "${pkgs.nil}/bin/nil";
        pyright-lsp = {
          command = "${pkgs.pyright}/bin/basedpyright-langserver";
          args = ["--stdio"];
          config.pyright.analysis = {
            autoSearchPaths = true;
            typeCheckingMode = "basic";
            diagnosticMode = "openFilesOnly";
            autoImportCompletions = true;
          };
        };
        ruff-lsp = {
          command = "${pkgs.ruff}/bin/ruff";
          args = ["server" "-q" "--preview"];
          config.settings.lint.ignore = ["I"];
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.alejandra}/bin/alejandra";
          language-servers = ["nil-lsp"];
        }
        {
          name = "python";
          auto-format = true;
          formatter.command = "bash";
          formatter.args = ["-c" "ruff check --fix --select I - | ruff format -"];
          language-servers = [
            "pyright-lsp"
            "ruff-lsp"
          ];
        }
      ];
    };
  };
}
