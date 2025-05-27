{
  programs.nixvim.plugins = {
    cmp-emoji.enable = true;
    cmp-git.enable = true;
    cmp-spell.enable = true;
    cmp-calc.enable = true;
    cmp-treesitter.enable = true;
    lsp.capabilities =
      # Lua
      ''
        capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      '';
    blink-compat = {
      enable = true;
      settings.debug = false;
      settings.impersonate_nvim_cmp = true;
    };

    blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "enter";
        signature.enabled = true;
        cmdline.sources = {};
        sources = {
          default = [
            "avante_commands"
            "avante_files"
            "avante_mentions"
            "buffer"
            "calc"
            "emoji"
            "git"
            "lsp"
            "path"
            "snippets"
            "spell"
          ];
          providers = {
            avante_commands = {
              name = "avante_commands";
              module = "blink.compat.source";
              score_offset = 90; # show at a higher priority than lsp
              opts = {};
            };
            avante_files = {
              name = "avante_files";
              module = "blink.compat.source";
              score_offset = 100; # show at a higher priority than lsp
              opts = {};
            };
            avante_mentions = {
              name = "avante_mentions";
              module = "blink.compat.source";
              score_offset = 1000; # show at a higher priority than lsp
              opts = {};
            };
            emoji = {
              name = "emoji";
              module = "blink.compat.source";
            };
            git = {
              name = "git";
              module = "blink.compat.source";
            };
            spell = {
              name = "spell";
              module = "blink.compat.source";
            };
            calc = {
              name = "calc";
              module = "blink.compat.source";
            };
          };
        };

        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "mono";
          kind_icons = {
            Text = "󰉿";
            Method = "";
            Function = "󰊕";
            Constructor = "󰒓";

            Field = "󰜢";
            Variable = "󰆦";
            Property = "󰖷";

            Class = "󱡠";
            Interface = "󱡠";
            Struct = "󱡠";
            Module = "󰅩";

            Unit = "󰪚";
            Value = "󰦨";
            Enum = "󰦨";
            EnumMember = "󰦨";

            Keyword = "󰻾";
            Constant = "󰏿";

            Snippet = "󱄽";
            Color = "󰏘";
            File = "󰈔";
            Reference = "󰬲";
            Folder = "󰉋";
            Event = "󱐋";
            Operator = "󰪚";
            TypeParameter = "󰬛";
            Error = "󰏭";
            Warning = "󰏯";
            Information = "󰏮";
            Hint = "󰏭";

            Emoji = "🤶";
          };
        };
        completion = {
          menu = {
            draw = {
              gap = 1;
              treesitter = ["lsp"];
              columns = [
                {
                  __unkeyed-1 = "label";
                }
                {
                  __unkeyed-1 = "kind_icon";
                  __unkeyed-2 = "kind";
                  gap = 1;
                }
                {__unkeyed-1 = "source_name";}
              ];
            };
          };
          trigger.show_in_snippet = false;
          documentation = {
            auto_show = true;
            window.border = "rounded";
          };
          accept.auto_brackets.enabled = true;
        };
        fuzzy.prebuilt_binaries.download = false;
      };
    };
  };
}
