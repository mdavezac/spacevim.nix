{pkgs, ...}: {
  imports = [
    ./mini-clue.nix
    ./lualine.nix
    ./bufferline.nix
    ./fzf-lua.nix
    ./noice.nix
    ./flash.nix
    ./neotree.nix
    ./dashboard.nix
    ./ai.nix
  ];
  programs.nixvim.plugins = {
    notify.enable = true;
    persistence.enable = true;
    mini.modules.icons = {};
    tmux-navigator = {
      settings.disable_when_zoomed = 1;
      settings.save_on_switch = 1;
      enable = true;
    };
    grug-far = {
      enable = true;
      settings = {
        engine = "ripgrep";
        enines.ripgrep = {
          path = "${pkgs.ripgrep}/bin/rg";
          showReplaceDiff = true;
        };
      };
      lazyLoad.settings.keys = [
        {
          __unkeyed-1 = "<leader>r";
          __unkeyed-2.__raw = ''
            function()
              local grug = require("grug-far")
              local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
              grug.open({
                transient = true,
                prefills = {
                  filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                },
              })
            end
          '';
          desc = "Search & Replace";
        }
      ];
    };
  };
  programs.nixvim.keymaps = [
    {
      key = "<leader>bb";
      action = "<cmd>b#<enter>";
      options.desc = "Previous buffer";
      options.silent = true;
    }
    {
      key = "<leader>ud";
      action = "<cmd>Noice dismiss<enter>";
      options.desc = "Dismiss notifications";
      options.silent = true;
    }
    {
      key = "<leader>ur";
      action = "<cmd>new | put =split(&runtimepath, ',')<enter>";
      options.desc = "Show runtimepaths";
      options.silent = true;
    }
    {
      key = "<leader>bD";
      action.__raw = ''
        function(n)
            require("snacks").bufdelete(n)
        end
      '';
      options.desc = "Deleter Buffer";
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
      key = "<leader>w=";
      action = "<C-w>=";
      options.desc = "Equalize window sizes";
    }
    {
      key = "<leader>wh";
      action = "<C-w>h";
      options.desc = "Focus left";
    }
    {
      key = "<leader>wl";
      action = "<C-w>l";
      options.desc = "Focus right";
    }
    {
      key = "<leader>wk";
      action = "<C-w>k";
      options.desc = "Focus up";
    }
    {
      key = "<leader>wj";
      action = "<C-w>j";
      options.desc = "Focus down";
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
