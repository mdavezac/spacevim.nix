{...}: {
  programs.nixvim.plugins.sidekick = {
    enable = true;
    settings = {
      # NES requires the Copilot language server; Sidekick's CLI integration
      # is independent of it.
      nes.enabled = false;
      cli = {
        mux = {
          enabled = true;
          backend = "tmux";
        };
        tools.codex.cmd = ["codex"];
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      key = "<leader>aa";
      action.__raw = ''
        function()
          require("sidekick.cli").toggle()
        end
      '';
      options.desc = "Sidekick Toggle Codex";
    }
    {
      key = "<leader>as";
      action.__raw = ''
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end
      '';
      options.desc = "Sidekick Select CLI";
    }
    {
      key = "<leader>af";
      action.__raw = ''
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end
      '';
      options.desc = "Sidekick Send File";
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
      mode = ["n" "t" "i" "x"];
    }
  ];
}
