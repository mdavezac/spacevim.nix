{
  imports = [./lualine.nix ./noice.nix ./mini-clue.nix ./noice.nix ./fzf-lua.nix];
  programs.nixvim.colorschemes.base16.enable = true;
  programs.nixvim.plugins = {
    barbar.enable = true;
    mini.modules.icons = {};
    mini.modules.files = {};
  };
  programs.nixvim.keymaps = [
    {
      action = "<cmd>bn<enter>";
      key = "]b";
      options.desc = "Next buffer";
      options.silent = true;
    }
    {
      key = "[b";
      action = "<cmd>bp<enter>";
      options.desc = "Previous buffer";
      options.silent = true;
    }
    {
      key = "]t";
      action = "<cmd>tn<enter>";
      options.desc = "Next tab";
      options.silent = true;
    }
    {
      key = "[t";
      action = "<cmd>tp<enter>";
      options.desc = "Previous tab";
      options.silent = true;
    }
    {
      key = "<leader>e";
      action = "lua MiniFiles.open()";
      options.desc = "Explore files";
    }
  ];
}
