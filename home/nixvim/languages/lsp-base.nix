{
  lib,
  config,
  ...
}: {
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    onAttach = lib.mkIf config.programs.nixvim.plugins.navic.enable ''
      if client:supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, bufnr)
      end
    '';
    keymaps = {
      silent = true;
      lspBuf = {
        gd = {
          action = "definition";
          desc = "Goto Definition";
        };
        gr = {
          action = "references";
          desc = "Goto References";
        };
        gD = {
          action = "declaration";
          desc = "Goto Declaration";
        };
        gI = {
          action = "implementation";
          desc = "Goto Implementation";
        };
        gT = {
          action = "type_definition";
          desc = "Type Definition";
        };
        "<leader>ca" = {
          action = "code_action";
          desc = "Code Action";
        };
        "<leader>cr" = {
          action = "rename";
          desc = "Rename";
        };
      };
      diagnostic = {
        "<leader>cd" = {
          action = "open_float";
          desc = "Line Diagnostics";
        };
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      key = "]d";
      mode = "n";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = 1, float = true })
        end
      '';
      options = {
        desc = "Next Diagnostic";
        silent = true;
      };
    }
    {
      key = "[d";
      mode = "n";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = -1, float = true })
        end
      '';
      options = {
        desc = "Previous Diagnostic";
        silent = true;
      };
    }
  ];
}
