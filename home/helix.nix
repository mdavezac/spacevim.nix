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
        line-number = "relative";
        true-color = true;
        trim-trailing-whitespace = true;
      };
      keys.normal.space.v = ''
        :sh ${pkgs.git}/bin/git diff -U0 -- %{buffer_name} | ${pkgs.gawk}/bin/awk -v l=%{cursor_line} '/^@@/ { if (found) exit; match($0, /\+[0-9]+(,[0-9]+)?/); s=substr($0,RSTART+1,RLENGTH-1); split(s,a,","); start=a[1]; count=(a[2] ? a[2] : 1); end=start+count-1; found=(l>=start && l<=end); if (found) print; next } found { print }'
      '';
    };
    languages = {
      language-server = {
        nil-lsp.command = "${pkgs.nil}/bin/nil";
        pyrefly = {
          command = "${pkgs.pyrefly}/bin/pyrefly";
          args = ["lsp"];
        };
        # pyright-lsp = {
        #   command = "${pkgs.pyright}/bin/basedpyright-langserver";
        #   args = ["--stdio"];
        #   config.pyright.analysis = {
        #     autoSearchPaths = true;
        #     typeCheckingMode = "basic";
        #     diagnosticMode = "openFilesOnly";
        #     autoImportCompletions = true;
        #   };
        # };
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
            "pyrefly"
            "ruff-lsp"
          ];
        }
      ];
    };
  };
}
