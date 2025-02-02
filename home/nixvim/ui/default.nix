{
  imports = [
    ./mini-clue.nix
    ./lualine.nix
    ./fzf-lua.nix
    ./noice.nix
    ./flash.nix
    ./neotree.nix
    ./dashboard.nix
  ];
  programs.nixvim.colorschemes.base16.enable = true;
  programs.nixvim.plugins = {
    barbar.enable = true;
    notify.enable = true;
    persistence.enable = true;
    mini.modules.icons = {};
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
      key = "<leader>bb";
      action = "<cmd>b#<enter>";
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
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      key = "<C-l>";
      action = "<C-w>l";
    }
    {
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      key = "<space>|";
      action = "<cmd>vsplit<enter>";
      options.desc = "Split vertically";
    }
    {
      key = "<space>-";
      action = "<cmd>split<enter>";
      options.desc = "Split horizontally";
    }
  ];
}
