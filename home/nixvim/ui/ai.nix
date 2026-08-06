{pkgs, nixvimPkgs ? null, ...}:
let
  flattenPlugin =
    if nixvimPkgs != null && nixvimPkgs.vimPlugins ? "flatten-nvim"
    then nixvimPkgs.vimPlugins.flatten-nvim
    else pkgs.vimPlugins.flatten-nvim;
  plenaryPlugin =
    if nixvimPkgs != null && nixvimPkgs.vimPlugins ? "plenary-nvim"
    then nixvimPkgs.vimPlugins.plenary-nvim
    else pkgs.vimPlugins.plenary-nvim;
in {
  programs.nixvim = {
    extraPlugins = [
      plenaryPlugin
      flattenPlugin
    ];
    extraConfigLua = ''
      require("flatten").setup({
        hooks = {
          -- Keep the nested editor alive until the host-side buffer is closed.
          -- This lets pi observe the completed edit before the guest exits.
          should_block = function(_)
            return true
          end,
        },
        window = {
          open = function(ctx)
            local target = ctx.stdin_buf or ctx.files[1]
            if not target then
              return
            end

            if vim.g.flatten_external_editor_float == false then
              local win = vim.fn.win_getid(vim.fn.winnr("#"))
              vim.api.nvim_win_set_buf(win, target.bufnr)
              return target.bufnr, win
            end

            local width = math.floor(vim.o.columns * 0.9)
            local height = math.floor(vim.o.lines * 0.8)
            local win = vim.api.nvim_open_win(target.bufnr, true, {
              relative = "editor",
              row = math.floor((vim.o.lines - height) * 0.5),
              col = math.floor((vim.o.columns - width) * 0.5),
              width = width,
              height = height,
              border = "rounded",
              style = "minimal",
              title = " Editor ",
              title_pos = "center",
            })

            vim.wo[win].relativenumber = true
            vim.wo[win].number = true
            vim.api.nvim_set_current_win(win)
            vim.cmd("startinsert")

            local function close_editor()
              if vim.bo[target.bufnr].modified then
                local name = vim.api.nvim_buf_get_name(target.bufnr)
                if name == "" then
                  vim.notify("External editor buffer has no file name", vim.log.levels.ERROR)
                  return
                end
                local parent = vim.fn.fnamemodify(name, ":h")
                if parent ~= "." then
                  vim.fn.mkdir(parent, "p")
                end
                vim.cmd("write")
              end
              if vim.api.nvim_buf_is_valid(target.bufnr) then
                vim.api.nvim_buf_delete(target.bufnr, { force = true })
              end
            end

            local function discard_editor()
              if vim.api.nvim_buf_is_valid(target.bufnr) then
                vim.api.nvim_buf_delete(target.bufnr, { force = true })
              end
            end

            vim.keymap.set("n", "q", close_editor, { buffer = target.bufnr, noremap = true, silent = true, desc = "Save and close external editor" })
            vim.keymap.set("n", "Q", discard_editor, { buffer = target.bufnr, noremap = true, silent = true, desc = "Discard and close external editor" })

            return target.bufnr, win
          end,
          focus = "first",
        },
      })

      -- Toggle where flattened external editors open:
      -- floating window by default, or the alternate Sidekick/terminal window.
      vim.g.flatten_external_editor_float = true
      vim.keymap.set("n", "<leader>ae", function()
        vim.g.flatten_external_editor_float = not vim.g.flatten_external_editor_float
        vim.notify("External editor: " .. (vim.g.flatten_external_editor_float and "floating" or "alternate window"))
      end, { desc = "Toggle external editor window" })
    '';
    plugins = {
      # CodeCompanion uses plenary and registers its completion provider with
      # blink.cmp for CodeCompanion chat/input buffers.
      codecompanion = {
        enable = false;
        settings = {
          adapters.acp.codex.__raw = ''
            function()
              return require("codecompanion.adapters").extend("codex", {
                defaults = {
                  auth_method = "chat-gpt";
                  session_config_options = {
                    model = "gpt-5.6-luna";
                    thought_level = "medium";
                  };
                },
                env = {},
              })
            end
          '';
          interactions.chat.adapter = "codex";
          interactions.cli = {
            agent = "codex";
            agents.codex = {
              cmd = "codex";
              args = [];
              description = "OpenAI Codex CLI";
              provider = "terminal";
            };
          };
          display.action_palette.provider = "snacks";
        };
      };
    };
  };
  programs.nixvim.extraPackages = [pkgs.codex pkgs.codex-acp];
}
