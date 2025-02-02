{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    enableDiagnostics = true;
    enableGitStatus = true;
    enableModifiedMarkers = true;
    autoCleanAfterSessionRestore = true;
    closeIfLastWindow = true;
    sources = ["filesystem" "buffers" "git_status"];
    extraOptions.open_files_do_not_replace_types = ["terminal" "Trouble" "trouble" "qf" "Outline"];
    filesystem.followCurrentFile.enabled = true;
    filesystem.bindToCwd = true;
    filesystem.useLibuvFileWatcher = true;
    buffers = {
      followCurrentFile.enabled = true;
      bindToCwd = true;
    };
  };
  programs.nixvim.keymaps = [
    {
      key = "<leader>e";
      action.__raw = ''
        function()
            require("neo-tree.command").execute({toggle=true})
        end
      '';
      options.desc = "Explore files";
    }
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
  ];
}
