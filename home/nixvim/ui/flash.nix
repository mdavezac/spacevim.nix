{
  programs.nixvim.plugins = {
    flash.enable = true;
  };
  programs.nixvim.keymaps = let
    actions = m: [
      {
        action.__raw = ''require("flash").jump'';
        key = "s";
        mode = m;
        options.desc = "Flash";
      }
      {
        action.__raw = ''require("flash").treesitter'';
        key = "S";
        mode = m;
        options.desc = "Treesitter Flash";
      }
    ];
  in
    (builtins.concatMap actions ["n" "x" "o"])
    ++ [
      {
        action.__raw = ''require("flash").remote'';
        key = "r";
        mode = "o";
        options.desc = "Remote Flash";
      }
      {
        action.__raw = ''require("flash").treesitter_search'';
        key = "R";
        mode = "o";
        options.desc = "Treesitter Search";
      }
      {
        action.__raw = ''require("flash").treesitter_search'';
        key = "R";
        mode = "x";
        options.desc = "Treesitter Search";
      }
    ];
}
