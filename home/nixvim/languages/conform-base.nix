{
  programs.nixvim.keymaps = [
    {
      key = "<leader>uf";
      action.__raw = ''
        function()
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify("Format on save: " .. (vim.b.disable_autoformat and "off" or "on"))
        end
      '';
      options.desc = "Toggle format on save";
    }
  ];

  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    luaConfig.pre = ''local slow_format_filetypes = {}'';
    settings = {
      format_on_save =
        # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
           end
        '';
      format_after_save =
        # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_fallback = true }
          end
        '';
      log_level = "warn";
      notify_on_error = false;
      notify_no_formatters = false;
    };
  };
}
