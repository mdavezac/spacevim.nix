{
  programs.nixvim.plugins = {
    lsp.servers.julials.enable = true;
    lsp.servers.julials.cmd = [
      "julia"
      "--project=@julials"
      "--startup-file=no"
      "--history-file=no"
      "${./julia_language_server.jl}"
    ];
    lsp.servers.julials = {
      filetypes = ["julia"];
      package = null;
      # rootMarkers = ["JuliaProject.toml" "Project.toml" "Manifest.toml"];
      autostart = true;
      settings.single_file_support = true;
    };
  };
}
