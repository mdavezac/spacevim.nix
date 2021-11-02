{
  inputs = { };
  outputs = { self, ... }: rec {

    module = { config, lib, pkgs, ... }: {
      config.nvim.plugins.start = lib.mkIf config.nvim.layers.terminal [
        pkgs.vimPlugins.nterm-nvim
        pkgs.vimPlugins.aniseed
      ];
      config.nvim.init.lua = lib.mkIf config.nvim.layers.terminal ''
        require'nterm.main'.init({
          maps = fales,  -- load defaut mappings
          shell = "${pkgs.fish}/bin/fish",
          size = 80,
          direction = "vertical", -- horizontal or vertical
          popup = 2000,     -- Number of miliseconds to show the info about the commmand. 0 to dissable
          popup_pos = "SE", --  one of "NE" "SE" "SW" "NW"
          autoclose = 2000, -- If command is sucesful, close the terminal after that number of miliseconds. 0 to disable
        })

        -- Optional, if you want to use the telescope extension
        require('telescope').load_extension('nterm')
        
        function term_toggle()
            local nterm = require('nterm.main')
            nterm.term_toggle()
            nterm.term_focus()
            vim.cmd('startinsert')
        end
      '';
      config.nvim.init.vim = lib.mkIf config.nvim.layers.terminal ''
        tnoremap <C-h> <C-\><C-N><C-w>h
        tnoremap <C-j> <C-\><C-N><C-w>j
        tnoremap <C-k> <C-\><C-N><C-w>k
        tnoremap <C-l> <C-\><C-N><C-w>l
        tnoremap <C-[> <C-\><C-N>
        tnoremap <C-q> <C-\><C-N><CMD>q<CR>
      '';
      config.nvim.which-key = lib.mkIf config.nvim.layers.terminal {
        "<space>" = {
          mode = "normal";
          keys."[\";\"]" = {
            command = "<cmd>lua term_toggle()<cr>";
            description = "Toggle terminal";
          };
        };
      };
    };
  };
}
    
