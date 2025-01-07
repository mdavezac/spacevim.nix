{
  imports = [./nix.nix ./lsp-base.nix ./conform-base.nix ./completion.nix ./rust.nix];
  programs.nixvim.plugins = {
    treesitter.enable = true;
    treesitter-context.enable = true;
    mini.modules.comment = {
      enable = true;
      comment = "<leader>/";
      comment_line = "<leader>/";
      comment_visual = "<leader>/";
      textobject = "<leader>/";
    };
  };
}
