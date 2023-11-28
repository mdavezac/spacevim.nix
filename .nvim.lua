return {
  { "uloco/bluloco.nvim", lazy = false, priority = 1000, dependencies = { "rktjmp/lush.nvim" } },
  {
    "LazyVim/LazyVim",
    dir = require("config.directories") .. "/LazyVim",
    opts = { colorscheme = "bluloco-dark" },
  },
}
