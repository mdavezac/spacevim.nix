{
  programs.nixvim = {
    opts = {
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    plugins.nvim-ufo.enable = true;

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
