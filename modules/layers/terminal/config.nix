{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.spacenix.layers;
  enable = cfg.terminal.enable;
  enable-repl =
    enable
    && cfg.terminal.repl.enable
    && (
      (builtins.length (builtins.attrValues cfg.terminal.repl)) > 0
    );
in {
  config.nvim.plugins.start = [
    pkgs.vimPlugins.flatten-nvim
    (lib.mkIf enable pkgs.vimPlugins.toggleterm-nvim)
    (lib.mkIf enable-repl pkgs.vimPlugins.iron-nvim)
  ];
  config.nvim.init = lib.mkIf enable {
    lua = let
      repls = cfg.terminal.repl._default_repls // cfg.terminal.repl.repls;
      preferred = builtins.concatStringsSep "\n        " (
        builtins.attrValues
        (builtins.mapAttrs (k: v: ''${k} = ${v},'') repls)
      );
      repl = ''
        local iron = require('iron.core');
        iron.setup({
           config = {
               repl_definition = {
                   ${preferred}
               },
               repl_open_cmd = ${cfg.terminal.repl.repl-open-cmd},
           }
        })
        require('iron.view').split.vertical.botright(
          "50%", { number = false, relativenumber = false }
        )
      '';
      toggleterm = ''
        require("toggleterm").setup {
            size=100,
            shell="${pkgs.fish}/bin/fish",
            direction="vertical",
            insert_mappings=false,
            terminal_mappings=false,
        }

        function _G.set_terminal_keymaps()
          local opts = {noremap = true}
          vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
          vim.api.nvim_buf_set_keymap(0, 't', '<C-[>', [[<C-\><C-n>]], opts)
          vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
          vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
          vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
          vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
          vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
        end
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({
            cmd = "${pkgs.lazygit}/bin/lazygit",
            direction = "float",
            float_opts = {
              border = "double",
            },
        })
        local shell = Terminal:new({ shell="${pkgs.fish}/bin/fish" })

        function _lazygit_toggle()
          lazygit:toggle()
        end
        function _shell_toggle()
          shell:toggle()
        end


        require("flatten").setup({
            callbacks = {
                pre_open = function()
                    -- Close toggleterm when an external open request is received
                    require("toggleterm").toggle(0)
                end,
                post_open = function(bufnr, winnr, ft)
                    if ft == "gitcommit" then
                        -- If the file is a git commit, create one-shot autocmd to delete it on write
                        -- If you just want the toggleable terminal integration, ignore this bit and only use the
                        -- code in the else block
                        vim.api.nvim_create_autocmd(
                            "BufWritePost",
                            {
                                buffer = bufnr,
                                once = true,
                                callback = function()
                                    -- This is a bit of a hack, but if you run bufdelete immediately
                                    -- the shell can occasionally freeze
                                    vim.defer_fn(
                                        function()
                                            vim.api.nvim_buf_delete(bufnr, {})
                                        end,
                                        50
                                    )
                                end
                            }
                        )
                    else
                        -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
                        -- This gives the appearance of the window opening independently of the terminal
                        require("toggleterm").toggle(0)
                        vim.api.nvim_set_current_win(winnr)
                    end
                end,
                block_end = function()
                    -- After blocking ends (for a git commit, etc), reopen the terminal
                    require("toggleterm").toggle(0)
                end
           }
        })
      '';
    in
      builtins.concatStringsSep "\n" [
        toggleterm
        (
          if enable-repl
          then repl
          else ""
        )
      ];
  };
  config.nvim.post.vim = lib.mkIf enable-repl ''
    set scrollback=100000
    let g:iron_map_defaults = 0
    let g:iron_map_extended = 0
  '';
}
