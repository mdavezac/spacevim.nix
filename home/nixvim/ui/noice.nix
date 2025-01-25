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
        view = "notify";
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
      presets = {
        bottom_search = true;
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
