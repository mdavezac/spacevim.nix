{
  pkgs,
  inputs,
  ...
}: {
  programs.nixvim.extraPlugins = [
    pkgs.vimPlugins.unison
    # (pkgs.vimUtils.buildVimPlugin {
    #   name = "unison";
    #   src = let
    #     path = pkgs.fetchFromGitHub {
    #       owner = "unisonweb";
    #       repo = "unison";
    #       rev = "trunk";
    #       hash = "sha256-/ET90h2pv+OgwQj6VPSVJ/Fbmw3A16ppyVq6MBxIpG0=";
    #     };
    #   in "${path}/editor-support/vim";
    # })
  ];
  programs.nixvim.plugins.lsp.servers.unison = {
    enable = true;
    package = pkgs.unison-ucm;
  };
}
