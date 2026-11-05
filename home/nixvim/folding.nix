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
        function()
          -- Ufo supports one primary provider and one fallback only.
          -- Catch Tree-sitter's fallback exception so no folds are applied
          -- when neither LSP nor Tree-sitter can provide them.
          return {
            "lsp",
            function(bufnr)
              local ok, ranges = pcall(require("ufo.provider.treesitter").getFolds, bufnr)
              return ok and ranges or nil
            end,
          }
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
