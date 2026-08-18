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
    })
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
    - When queried about slack, notion, emails, granola, google drive, or calendars, rely on
      the Catapult MCP.
  '';
}
