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
    conform-nvim.settings.formatters.runic = {
      command = "julia";
      args = ["--project=@runic" "-e" "using Runic; exit(Runic.main(ARGS))"];
    };
    conform-nvim.settings.formatters_by_ft.julia = ["runic"];
    conform-nvim.settings.default_format_opts.timeout_ms = 10000;
  };
}
