{
  programs.nixvim.plugins.snacks = {
    enable = true;
    settings.bigfile.enable = false;
    settings.quickfile.enable = false;
    settings.notifier.enable = false;
    settings.statuscolumn.enable = false;
    settings.words.enable = false;
  };

  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings.options = {
      always_show_bufferline = false;
      close_command.__raw = ''
        function(n)
            require("Snacks").bufdelete(n)
        end
      '';
      diagnostics = "nvim_lsp";
      diagnostics_indicator = ''
        function(count, level, diagnostics_dict, context)
          local s = ""
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " "
              or (e == "warning" and " " or "" )
            if(sym ~= "") then
              s = s .. " " .. n .. sym
            end
          end
          return s
        end
      '';
      separator_style = "slant";
      themable = true;
      offsets = [
        {
          filetype = "neo-tree";
          highlight = "Directory";
          text = "File Explorer";
          text_align = "center";
        }
      ];
    };
  };
  programs.nixvim.keymaps = [
    {
      key = "gb";
      action = "<cmd>BufferLinePick<cr>";
      options.desc = "Pick buffer";
    }
    {
      key = "gB";
      action = "<cmd>BufferLinePickClose<cr>";
      options.desc = "Pick&Close buffer";
    }
    {
      action = "<cmd>BufferLineCycleNext<enter>";
      key = "]b";
      options.desc = "Next buffer";
      options.silent = true;
    }
    {
      key = "[b";
      action = "<cmd>BufferLineCyclePrev<enter>";
      options.desc = "Previous buffer";
      options.silent = true;
    }
    {
      action = "<cmd>BufferLineMoveNext<enter>";
      key = "]B";
      options.desc = "Move buffer right";
      options.silent = true;
    }
    {
      key = "[B";
      action = "<cmd>BufferLineMovePrev<enter>";
      options.desc = "Move buffer left";
      options.silent = true;
    }
    {
      key = "<leader>bp";
      action = "<cmd>BufferLineTogglePin<enter>";
      options.desc = "Pin buffer";
      options.silent = true;
    }
    {
      key = "<leader>bP";
      action = "<cmd>BufferLineGroupClose ungrouped<CR>";
      options.desc = "Delete unpinned buffers";
      options.silent = true;
    }
  ];
}
