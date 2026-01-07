{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      enableDiagnostics = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      autoCleanAfterSessionRestore = true;
      closeIfLastWindow = true;
      sources = ["filesystem" "buffers" "git_status" "document_symbols"];
      extraOptions.open_files_do_not_replace_types = [
        "terminal"
        "Trouble"
        "trouble"
        "qf"
        "Outline"
        "Neotest Summary"
      ];
      filesystem = {
        follow_current_file.enabled = true;
        bind_to_cwd = true;
        use_libuv_file_watcher = true;
      };
      document_symbols.follow_cursor = true;
      buffers = {
        follow_current_file.enabled = true;
        bind_to_cwd = true;
      };
    };
  };
  programs.nixvim.keymaps = let
    files = key: {
      inherit key;
      action.__raw = ''
        function()
            require("neo-tree.command").execute({toggle=true})
        end
      '';
      options.desc = "Explore files";
    };
  in [
    (files "<leader>e")
    (files "<leader>fe")
    {
      key = "<leader>ge";
      action.__raw = ''
        function()
            require("neo-tree.command").execute({toggle=true, source = "git_status"})
        end
      '';
      options.desc = "Git explorer";
    }
    {
      key = "<leader>be";
      action.__raw = ''
        function()
            require("neo-tree.command").execute({toggle=true, source = "buffers"})
        end
      '';
      options.desc = "Buffer explorer";
    }
    {
      key = "<leader>ce";
      action.__raw = ''
        function()
            require("neo-tree.command").execute({toggle=true, source = "document_symbols"})
        end
      '';
      options.desc = "Symbols explorer";
    }
  ];
}
