{
  programs.nixvim = {
    opts = {
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    plugins.nvim-ufo = {
      enable = true;
      settings.provider_selector.__raw = ''
        function(bufnr, filetype, buftype)
          if filetype == "" or buftype == "nofile" then
            return "indent"
          end

          local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
          if not ok or not parser then
            return "indent"
          end

          return { "lsp", "treesitter" }
        end
      '';
    };

    keymaps = [
      {
        key = "zR";
        mode = "n";
        action.__raw = ''require("ufo").openAllFolds'';
        options.desc = "Open all folds";
      }
      {
        key = "zM";
        mode = "n";
        action.__raw = ''require("ufo").closeAllFolds'';
        options.desc = "Close all folds";
      }
      {
        key = "zK";
        mode = "n";
        action.__raw = ''require("ufo").peekFoldedLinesUnderCursor'';
        options.desc = "Peek folded lines";
      }
    ];
  };
}
