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
        typescript-language-server = with pkgs.nodePackages; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = [
            "--stdio"
            "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"
          ];
        };
        nil-lsp.command = "${pkgs.nil}/bin/nil";
        based-pyright-lsp = {
          command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
          args = ["--stdio"];
          config.basedpyright.analysis = {
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
            "based-pyright-lsp"
            "ruff-lsp"
          ];
        }
      ];
    };
  };
}
