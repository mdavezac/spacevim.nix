{
  # Cargo currently accepts TOML 1.0; do not let Tombi format or lint Cargo
  # manifests with rules that may emit newer TOML syntax.
  xdg.configFile."tombi/config.toml".text = ''
    [files]
    exclude = ["**/Cargo.toml"]
  '';

  programs.nixvim.plugins.lsp.servers.tombi.enable = true;
}
