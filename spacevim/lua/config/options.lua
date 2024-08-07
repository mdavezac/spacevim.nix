-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.wo.foldmethod = "expr"
vim.wo.foldenable = false
vim.opt.swapfile = false
vim.opt.pumblend = 0
vim.filetype.add({ extension = { nu = "nu" } })
vim.opt.runtimepath:append(vim.fn.expand("~/.local/state/nvim/tree-sitter"))
