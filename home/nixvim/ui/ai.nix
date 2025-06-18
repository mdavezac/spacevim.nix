{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [pkgs.vimPlugins.blink-cmp-avante];
    plugins.nui.enable = true;
    plugins.avante.enable = true;
    plugins.avante.package = pkgs.vimPlugins.avante-nvim;
    plugins.avante.settings = {
      providers.claude = {
        endpoint = "https://api.anthropic.com";
        model = "claude-3-5-haiku-20241022";
        extra_request_body.temperature = 0;
        extra_request_body.max_tokens = 4096;
      };
      providers.groq = {
        __inherited_from = "openai";
        api_key_name = "GROQ_API_KEY";
        endpoint = "https://api.groq.com/openai/v1/";
        model = "llama-3.3-70b-versatile";
        disable_tools = true;
        extra_request_body.temperature = 1;
        extra_request_body.max_tokens = 32768;
      };
      diff = {
        autojump = true;
        debug = false;
        list_opener = "copen";
      };
      highlights = {
        diff = {
          current = "DiffText";
          incoming = "DiffAdd";
        };
      };
      hints = {
        enabled = true;
      };
      mappings = {
        diff = {
          both = "cb";
          next = "]x";
          none = "c0";
          ours = "co";
          prev = "[x";
          theirs = "ct";
        };
      };
      provider = "claude";
      windows = {
        sidebar_header = {
          align = "center";
          rounded = true;
        };
        width = 30;
        wrap = true;
      };
    };
  };
}
