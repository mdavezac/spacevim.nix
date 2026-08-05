{pkgs, nixvimPkgs ? null, ...}:
let
  flattenPlugin =
    if nixvimPkgs != null && nixvimPkgs.vimPlugins ? "flatten-nvim"
    then nixvimPkgs.vimPlugins.flatten-nvim
    else pkgs.vimPlugins.flatten-nvim;
  plenaryPlugin =
    if nixvimPkgs != null && nixvimPkgs.vimPlugins ? "plenary-nvim"
    then nixvimPkgs.vimPlugins.plenary-nvim
    else pkgs.vimPlugins.plenary-nvim;
in {
  programs.nixvim = {
    extraPlugins = [
      plenaryPlugin
      flattenPlugin
    ];
    extraConfigLua = ''
      require("flatten").setup({
        window = {
          open = "alternate",
          focus = "first",
        },
      })
    '';
    plugins = {
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
  };
  programs.nixvim.extraPackages = [pkgs.codex pkgs.codex-acp];
}
