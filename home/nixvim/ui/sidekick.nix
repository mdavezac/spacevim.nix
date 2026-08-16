{pkgs, ...}: {
  programs.nixvim.plugins.sidekick = {
    enable = true;
    settings = {
      # NES requires the Copilot language server; Sidekick's CLI integration
      # is independent of it.
      nes.enabled = false;
      cli = {
        mux = {
          enabled = false;
          backend = "tmux";
          create = "window";
          # Keep more lines when the command output is reloaded from the mux.
          dump = 10000;
        };
        win = {
          layout = "float";
          bo = {
            # Keep large terminal history for scrollback in Sidekick.
            scrollback = 50000;
          };
          float = {
            width.__raw = "math.min(math.min(200, math.floor(vim.o.columns * 0.85)), vim.o.columns * 0.95)";
            height = 0.85;
            border = "rounded";
          };
          keys = {
            stopinsert = {
              __unkeyed-1 = "<C-[>";
              __unkeyed-2 = "stopinsert";
              mode = "t";
              desc = "enter terminal normal mode";
            };
            send-escape = {
              __unkeyed-1 = "<Esc>";
              __unkeyed-2.__raw = ''
                function()
                  vim.api.nvim_chan_send(vim.b.terminal_job_id, "\27")
                end
              '';
              mode = "t";
              desc = "send Escape to Sidekick CLI";
            };
          };
        };
        tools = {
          pi.args = ["-c"];
          claude = {};
          maki = {
            cmd = ["maki"];
            is_proc = "\\<maki\\>";
          };
          codex = {
            cmd = ["codex"];
            args = ["--resume" "last"];
            env = {
              VISUAL = "nvim";
              EDITOR = "nvim";
            };
          };
        };
      };
    };
  };

  programs.nixvim.extraPackages = [pkgs.maki];

  programs.nixvim.keymaps = [
    {
      key = "<C-/>";
      action.__raw = ''
        function()
          require("sidekick.cli").toggle()
        end
      '';
      options.desc = "Sidekick Toggle";
      mode = ["n" "x" "t"];
    }
    {
      key = "<C-_>";
      action.__raw = ''
        function()
          require("sidekick.cli").toggle()
        end
      '';
      options.desc = "Sidekick Toggle";
      mode = ["n" "x" "t"];
    }
    {
      key = "<leader>aa";
      action.__raw = ''
        function()
          require("sidekick.cli").toggle()
        end
      '';
      options.desc = "Sidekick Toggle Codex";
      mode = ["n" "x"];
    }
    {
      key = "<leader>as";
      action.__raw = ''
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end
      '';
      options.desc = "Sidekick Select CLI";
      mode = ["n" "x"];
    }
    {
      key = "<leader>af";
      action.__raw = ''
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end
      '';
      options.desc = "Sidekick Send File";
      mode = ["n" "x"];
    }
    {
      key = "<leader>at";
      action.__raw = ''
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end
      '';
      options.desc = "Sidekick Send This";
      mode = ["n" "x"];
    }
    {
      key = "<leader>av";
      action.__raw = ''
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end
      '';
      options.desc = "Sidekick Send Selection";
      mode = ["x"];
    }
    {
      key = "<leader>ap";
      action.__raw = ''
        function()
          require("sidekick.cli").prompt()
        end
      '';
      options.desc = "Sidekick Select Prompt";
      mode = ["n" "x"];
    }
    {
      key = "<leader>aF";
      action.__raw = ''
        function()
          require("sidekick.cli").focus()
        end
      '';
      options.desc = "Sidekick Focus";
      mode = ["n" "x"];
    }
  ];
}
