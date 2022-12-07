{ config, lib, pkgs, ... }:
let
  cfg = config.spacenix.layers.git;
  enable = cfg.enable;
in
{
  config.nvim.plugins.start = lib.mkIf enable [
    pkgs.vimPlugins.neogit
    pkgs.vimPlugins.gitsigns-nvim
    pkgs.vimPlugins.vim-diffview
    pkgs.vimPlugins.vim-hydra
  ];
  config.nvim.init.vim =
    let
      nvr = (
        "${pkgs.neovim-remote}/bin/nvr " +
        "--servername \${NVIM_LISTEN_ADDRESS:-~/.cache/config/nvr} " +
        "-cc split --remote-wait"
      );
    in
    lib.mkIf cfg.nvr
      ''
        if has('nvim')
          let $GIT_EDITOR = '${nvr}'
        endif
        autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
      '';
  config.nvim.init.lua = lib.mkIf enable ''
    require('neogit').setup {
      integrations = { diffview = true },
      auto_refresh = ${builtins.toString cfg.auto_refresh},
    }
    require('gitsigns').setup {
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
      },
      current_line_blame_formatter_opts = {
        relative_time = true
      },
      keymaps = {
        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
      },
    }
  '';
  config.nvim.post.lua = lib.mkIf (enable && config.spacenix.layers.base.enable) ''
    require('which-key').register({
        ["ih"] = [[Select hunk]],
        ["ah"] = [[Select hunk]],
    }, {mode="o", prefix=""})

    local gitsigns = require('gitsigns')
    local hint = [[
    _j_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
    _k_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
    _x_: reset hunk  _S_: stage buffer      ^ ^                 _/_: show base file
    ^
    ^ ^              _<Enter>_: Neogit              _q_: exit
    ]]
    require('hydra')({
          name = 'Git',
          hint = hint,
          config = {
             buffer = bufnr,
             color = 'red',
             invoke_on_body = true,
             hint = {
                border = 'rounded',
                type = 'window',
                position = 'bottom-right'
             },
             on_key = function() vim.wait(50) end,
             on_enter = function()
                vim.cmd 'mkview'
                vim.cmd 'silent! %foldopen!'
                gitsigns.toggle_linehl(true)
             end,
             on_exit = function()
                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd 'loadview'
                vim.api.nvim_win_set_cursor(0, cursor_pos)
                vim.cmd 'normal zv'
                gitsigns.toggle_linehl(false)
                gitsigns.toggle_deleted(false)
             end,
          },
          mode = {'n','x'},
          body = '<leader>gg',
          heads = {
             { 'j',
                function()
                   if vim.wo.diff then return ']c' end
                   vim.schedule(function() gitsigns.next_hunk() end)
                   return '<Ignore>'
                end,
                { expr = true, desc = 'next hunk' } },
             { 'k',
                function()
                   if vim.wo.diff then return '[c' end
                   vim.schedule(function() gitsigns.prev_hunk() end)
                   return '<Ignore>'
                end,
                { expr = true, desc = 'prev hunk' } },
             { 's',
                function()
                   local mode = vim.api.nvim_get_mode().mode:sub(1,1)
                   if mode == 'V' then -- visual-line mode
                      local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
                      vim.api.nvim_feedkeys(esc, 'x', false) -- exit visual mode
                      vim.cmd("'<,'>Gitsigns stage_hunk")
                   else
                      vim.cmd("Gitsigns stage_hunk")
                   end
                end,
                { desc = 'stage hunk' } },
             { 'u', gitsigns.undo_stage_hunk, { desc = 'undo last stage' } },
             { 'x', gitsigns.reset_hunk, { desc = 'reset hunk' } },
             { 'S', gitsigns.stage_buffer, { desc = 'stage buffer' } },
             { 'p', gitsigns.preview_hunk, { desc = 'preview hunk' } },
             { 'd', gitsigns.toggle_deleted, { nowait = true, desc = 'toggle deleted' } },
             { 'b', gitsigns.blame_line, { desc = 'blame' } },
             { 'B', function() gitsigns.blame_line{ full = true } end, { desc = 'blame show full' } },
             { '/', gitsigns.show, { exit = true, desc = 'show base file' } }, -- show the base of the file
             { '<Enter>', function() vim.cmd('Neogit') end, { exit = true, desc = 'Neogit' } },
             { 'q', nil, { exit = true, nowait = true, desc = 'exit' } },
          }
       }) 
  '';
}
