{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    render-markdown.enable = true;
    render-markdown.settings = {
      code.enabled = true;
      code.style = "language";
      code.sign = false;
      code.width = "block";
      code.right_pad = 1;
      heading.sign = true;
      heading.icons = [];
      checkbox.enabled = false;
      file_types = ["markdown" "rmd" "Avante"];
    };
    render-markdown.lazyLoad.settings.ft = ["markdown" "rmd" "Avante"];

    conform-nvim.enable = true;
    conform-nvim.settings.formatters_by_ft.markdown = ["deno_fmt"];
    conform-nvim.settings.formatters.deno_fmt.command = lib.getExe pkgs.deno;

    lsp.servers.markdown_oxide.enable = true;
  };
}
