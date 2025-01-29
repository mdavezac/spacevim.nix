{
  imports = [./mini-clue.nix ./lualine.nix ./fzf-lua.nix ./noice.nix ./flash.nix];
  programs.nixvim.colorschemes.base16.enable = true;
  programs.nixvim.plugins = {
    lazy.enable = true;
    barbar.enable = true;
    notify.enable = true;
    neo-tree = {
      enable = true;
      enableDiagnostics = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
    };
    persistence.enable = true;
    mini.modules.icons = {};
    mini.modules.starter = {
      content_hooks = {
        "__unkeyed-1.adding_bullet" = {
          __raw = "require('mini.starter').gen_hook.adding_bullet()";
        };
        "__unkeyed-2.indexing" = {
          __raw = "require('mini.starter').gen_hook.indexing('all', { 'actions' })";
        };
        "__unkeyed-3.padding" = {
          __raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
        };
      };
      evaluate_single = true;
      header = ''
        ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
        ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
        ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
        ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
        ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
      '';
      items = {
        "__unkeyed-1.actions" = [
          {
            name = "Edit new buffer";
            action = "enew";
            section = "actions";
          }
          {
            name = "Quit Neovim";
            action = "qall";
            section = "actions";
          }
          {
            action.__raw = "require('persistence').load";
            name = "Reload last session";
            section = "actions";
          }
        ];
        "__unkeyed-2.recent_files_current_directory" = {
          __raw = "require('mini.starter').sections.recent_files(5, false)";
        };
      };
    };
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
      key = "<leader>e";
      action = "<cmd>Neotree toggle<enter>";
      options.desc = "Explore files";
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
