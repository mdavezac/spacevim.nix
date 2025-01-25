{
  programs.nixvim.plugins.nui.enable = true;
  programs.nixvim.plugins.noice = {
    enable = true;
    settings = {
      notify = {
        enabled = true;
        view = "notify";
      };
      messages = {
        enabled = true;
        view = "mini";
      };
      lsp = {
        message = {
          enabled = false;
        };
        progress = {
          enabled = false;
          view = "mini";
        };
      };
      popupmenu = {
        enabled = true;
        backend = "nui";
      };
      routes = [
        {
          filter.find = "git commit";
          filter.event = "msg_show";
          skip = true;
        }
        {
          filter.find = ".git/COMMIT_EDITMSG";
          filter.event = "msg_show";
          skip = true;
        }
      ];
      presets = {
        bottom_search = false;
        command_palette = true;
        long_message_to_split = true;
      };
      cmdline = {
        relative = "editor";
        format = {
          filter = {
            pattern = [
              ":%s*%%s*s:%s*"
              ":%s*%%s*s!%s*"
              ":%s*%%s*s/%s*"
              "%s*s:%s*"
              ":%s*s!%s*"
              ":%s*s/%s*"
            ];
            icon = "";
            lang = "regex";
          };
          replace = {
            pattern = [
              ":%s*%%s*s:%w*:%s*"
              ":%s*%%s*s!%w*!%s*"
              ":%s*%%s*s/%w*/%s*"
              "%s*s:%w*:%s*"
              ":%s*s!%w*!%s*"
              ":%s*s/%w*/%s*"
            ];
            icon = "󱞪";
            lang = "regex";
          };
          range = {
            pattern = [
              ":%s*%%s*s:%w*:%w*:%s*"
              ":%s*%%s*s!%w*!%w*!%s*"
              ":%s*%%s*s/%w*/%w*/%s*"
              "%s*s:%w*:%w*:%s*"
              ":%s*s!%w*!%w*!%s*"
              ":%s*s/%w*/%w*/%s*"
            ];
            icon = "";
            lang = "regex";
          };
        };
      };
    };
  };
}
