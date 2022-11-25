let
  evalModules = pkgs: configuration: pkgs.lib.evalModules {
    modules = [ ./layers { _module.args.pkgs = pkgs; } ]
      ++ [ configuration ];
  };
  customNeovim = pkgs: configuration:
    let
      module = evalModules pkgs configuration;
    in
    pkgs.wrapNeovim pkgs.neovim {
      configure = {
        customRC =
          module.config.nvim.init.vim
          + ("\n\nlua <<EOF\n" + module.config.nvim.init.lua + "\nEOF\n\n")
          + module.config.nvim.post.vim
          + ("\n\nlua <<EOF\n" + module.config.nvim.post.lua + "\nEOF");
        packages.spacevimnix = {
          start = pkgs.lib.unique module.config.nvim.plugins.start;
          opt = pkgs.lib.unique module.config.nvim.plugins.opt;
        };
      };
    };
in
{
  inherit evalModules customNeovim;
  default_config.nvim = {
    languages.python = true;
    languages.nix = true;
    languages.markdown = true;
    colorscheme = "monochrome";
    layers.neorg.workspaces = [
      {
        name = "neorg";
        path = "~/neorg/";
        key = "n";
      }
    ];
    layers.neorg.gtd = "neorg";
    layers.completion.sources.other = [
      { name = "buffer"; group_index = 3; priority = 100; }
      { name = "path"; group_index = 2; priority = 50; }
      { name = "emoji"; group_index = 2; priority = 50; }
    ];
    layers.completion.sources."/" = [{ name = "buffer"; }];
    layers.completion.sources.":" = [{ name = "cmdline"; }];
  };
}
