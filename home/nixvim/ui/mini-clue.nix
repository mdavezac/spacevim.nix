{
  programs.nixvim.plugins.mini.modules.clue = {
    window = {
      delay = 500;
      config = {
        width.__raw = ''
          math.floor(0.318 * vim.o.columns)
        '';
        row = "auto";
        col = "auto";
        anchor = "SE";
      };
    };
    triggers = [
      {
        mode = "n";
        keys = "<leader>";
      }
      {
        mode = "x";
        keys = "<leader>";
      }
      {
        mode = "i";
        keys = "<C-x>";
      }
      {
        mode = "n";
        keys = "g";
      }
      {
        mode = "x";
        keys = "g";
      }
      {
        mode = "n";
        keys = "'";
      }
      {
        mode = "n";
        keys = "`";
      }
      {
        mode = "n";
        keys = "]";
      }
      {
        mode = "n";
        keys = "[";
      }
      {
        mode = "x";
        keys = "'";
      }
      {
        mode = "x";
        keys = "`";
      }
      {
        mode = "n";
        keys = "z";
      }
      {
        mode = "x";
        keys = "z";
      }
      {
        mode = "n";
        keys = ''"'';
      }
      {
        mode = "x";
        keys = ''"'';
      }
    ];
    clues = [
      {__raw = "require('mini.clue').gen_clues.builtin_completion()";}
      {__raw = "require('mini.clue').gen_clues.g()";}
      {__raw = "require('mini.clue').gen_clues.marks()";}
      {__raw = "require('mini.clue').gen_clues.registers()";}
      {__raw = "require('mini.clue').gen_clues.windows()";}
      {__raw = "require('mini.clue').gen_clues.z()";}
      {
        mode = "n";
        keys = "<Leader>c";
        desc = "+Code";
      }
      {
        mode = "n";
        keys = "<Leader>u";
        desc = "+UI";
      }
      {
        mode = "n";
        keys = "<Leader>b";
        desc = "+Buffer";
      }
      {
        mode = "n";
        keys = "<Leader>g";
        desc = "+Git";
      }
      {
        mode = "n";
        keys = "<Leader>f";
        desc = "+File";
      }
      {
        mode = "n";
        keys = "<Leader>w";
        desc = "+Window";
      }
      {
        mode = "n";
        keys = "<Leader>a";
        desc = "+AI";
      }
    ];
  };
}
