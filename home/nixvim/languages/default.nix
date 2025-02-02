{config, ...}: {
  imports = [
    ./nix.nix
    ./lsp-base.nix
    ./conform-base.nix
    ./completion.nix
    ./rust.nix
    ./python.nix
    ./lean.nix
  ];
  programs.nixvim.plugins = {
    treesitter.enable = true;
    treesitter-context.enable = !config.programs.nixvim.plugins.navic.enable;
    navic.enable = true;
    mini.modules.comment = {
      enable = true;
      comment = "gc";
      comment_line = "gcc";
      comment_visual = "gc";
      textobject = "gc";
    };
  };
}
