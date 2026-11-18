{pkgs, ...}: {
  home.packages = [pkgs.maki];

  home.file.".config/maki/mcp.toml".text = ''
    [mcp.linear]
    url = "https://mcp.linear.app/mcp"

    [mcp.logfire]
    url = "https://logfire-us.pydantic.dev/mcp"

    [mcp.catapult]
    url = "https://dev.api.catapultlabs.xyz/mcp"
  '';
  home.file.".config/maki/init.lua".text = ''
    maki.setup({
      agent = {
        compaction_buffer = 102000,
      },
      provider = {
        default_model = "openai/gpt-5.6-terra",
        allowed_models = {
          "openai/gpt-6.1-sol",
          "openai/gpt-6-luna",
          "openai/gpt-5.6-terra",
          "openai/gpt-6-astra",
        },
      }
    })

    require("review-pr")
    require("semble")

    maki.defer_fn(function()
      maki.keymap.set({ "n", "i" }, "<C-p>", function()
        local ok, err = maki.ui.action("model_picker")
        if not ok then
          maki.ui.flash("Could not open models: " .. tostring(err))
        end
      end, { desc = "Choose model" })
    end, 0)

    maki.keymap.set({ "n", "i" }, "<C-i>", function()
      local ok, err = maki.api.run_command("/sessions")
      if not ok then
        maki.ui.flash("Could not open sessions: " .. tostring(err))
      end
    end, { desc = "Choose session" })
  '';
  home.file.".config/maki/lua/review-pr.lua".source = ./maki/review-pr.lua;
  home.file.".config/maki/lua/semble.lua".source = ./maki/semble.lua;
  home.file.".config/maki/plugin.toml".text = ''
    [permissions]
    env = true
    run = true
  '';
  home.file.".config/maki/AGENTS.md".text = ''
    # AGENTS

    - Do not patronize or otherwise suck up to the user. Do not tell them they are right, or that
      their query is a good one unless until it is material to the query itself. Stay concise and
      professional.
    - When a file devenv.nix is present, prefix bash commands with
      `SHELL=bash devenv shell`.
    - When queried about linear issues, use the appropriate mcp
    - Linear issues are often coded as C-XYZ where XYZ are integers
    - Never change the status of a linear issue
    - When queried about slack, notion, emails, granola, google drive, or calendars, rely on
      the Catapult MCP.
    - Never run git reset or otherwise unstage changes. The user may stage changes deliberately to
      inspect the most recent changes introduced by the agent; preserve their index state.
    - Be clever when adding tests. Prefer testing the functionality and behavior of the app, and the
      contract boundary of functions and classes. Avoid tests that merely check one implementation
      tactic over another.
  '';
}
