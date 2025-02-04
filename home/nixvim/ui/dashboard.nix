{
  programs.nixvim.plugins.mini.modules.starter = {
    content_hooks = {
      "__unkeyed-1.adding_bullet" = {
        __raw = "require('mini.starter').gen_hook.adding_bullet()";
      };
      "__unkeyed-2.indexing" = {
        __raw = "require('mini.starter').gen_hook.indexing('all', { 'actions' })";
      };
      "__unkeyed-3.padding" = {
        __raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
      };
    };
    evaluate_single = true;
    header = ''
      ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
      ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
      ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
      ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
      ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
    '';
    items = {
      "__unkeyed-1.actions" = [
        {
          name = "Edit new buffer";
          action = "enew";
          section = "actions";
        }
        {
          name = "Quit Neovim";
          action = "qall";
          section = "actions";
        }
        {
          action.__raw = "require('persistence').load";
          name = "Reload last session";
          section = "actions";
        }
      ];
      "__unkeyed-2.recent_files_current_directory" = {
        __raw = "require('mini.starter').sections.recent_files(5, true)";
      };
    };
  };
}
