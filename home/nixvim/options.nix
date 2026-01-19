{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      # Disable useless providers
      loaded_ruby_provider = 0; # Ruby
      loaded_perl_provider = 0; # Perl
      loaded_python_provider = 0; # Python 2
    };

    clipboard = {
      # Use system clipboard
      register = "unnamedplus";
    };

    opts = {
      sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,terminal";
      updatetime = 100; # Faster completion
      relativenumber = true; # Relative line numbers
      number = true; # Display the absolute line number of the current line
      hidden = true; # Keep closed buffer open in the background
      mouse = "n"; # Enable mouse control
      splitbelow = true; # A new window is put below the current one
      splitright = true; # A new window is put right of the current one
      swapfile = false; # Disable the swap file
      modeline = true; # Tags such as 'vim:ft=sh'
      modelines = 100; # Sets the type of modelines
      undofile = true; # Automatically save and restore undo history
      incsearch = true; # Incremental search: show match for partly typed search command
      inccommand = "split"; # Search and replace: preview changes in quickfix list
      ignorecase = true;
      smartcase = true;
      scrolloff = 8; # Number of screen lines to show around the cursor
      cursorline = false; # Highlight the screen line of the cursor
      cursorcolumn = false; # Highlight the screen column of the cursor
      signcolumn = "yes"; # Whether to show the signcolumn
      colorcolumn = "+1"; # Columns to highlight
      laststatus = 3; # When to use a status line for the last window
      fileencoding = "utf-8"; # File-content encoding for the current buffer
      termguicolors = true; # Enables 24-bit RGB color in the |TUI|
      spell = false; # Highlight spelling mistakes (local to window)
      wrap = true; # Prevent text from wrapping
      tabstop = 4; # Number of spaces a <Tab> in the text stands for (local to buffer)
      shiftwidth = 4; # Number of spaces used for each step of (auto)indent (local to buffer)
      expandtab = true; # Expand <Tab> to spaces in Insert mode (local to buffer)
      autoindent = true; # Do clever autoindenting
      textwidth = 100;
      foldlevel = 99;
      cmdheight = 0;
    };

    autoCmd = [
      {
        callback.__raw = ''
          function()
            if require("nvim-treesitter.parsers").has_parser() then
              vim.opt.foldmethod = "expr"
              vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            else
              vim.opt.foldmethod = "syntax"
            end
          end
        '';
        event = ["FileType"];
      }
    ];
    diagnostic.settings.virtual_lines = true;
    diagnostic.settings.virtual_text = false;
    diagnostic.settings.signs = true;
  };
}
