{pkgs, ...}: {
  programs.nixvim.plugins = {
    # CodeCompanion uses plenary and registers its completion provider with
    # blink.cmp for CodeCompanion chat/input buffers.
    codecompanion = {
      enable = false;
      settings = {
        adapters.acp.codex.__raw = ''
          function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chat-gpt";
                session_config_options = {
                  model = "gpt-5.6-luna";
                  thought_level = "medium";
                };
              },
              env = {},
            })
          end
        '';
        interactions.chat.adapter = "codex";
        interactions.cli = {
          agent = "codex";
          agents.codex = {
            cmd = "codex";
            args = [];
            description = "OpenAI Codex CLI";
            provider = "terminal";
          };
        };
        display.action_palette.provider = "snacks";
      };
    };
  };

  programs.nixvim.extraPlugins = [pkgs.vimPlugins.plenary-nvim];
  programs.nixvim.extraPackages = [pkgs.codex pkgs.codex-acp];
}
