{
  programs.nixvim = {
    plugins.neogit = {
      enable = true;
      lazyLoad.settings.cmd = "Neogit";
    };
    plugins.gitsigns = {
      enable = true;
      settings.__raw = ''
        {
          signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
          },
          signs_staged = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
          },
          on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc)
              vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            -- stylua: ignore start
            map("n", "]h", function()
              if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
              else
                gs.nav_hunk("next")
              end
            end, "Next Hunk")
            map("n", "[h", function()
              if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
              else
                gs.nav_hunk("prev")
              end
            end, "Prev Hunk")
            map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
            map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
            map({ "n", "v" }, "<leader>ga", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
            map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
            map("n", "<leader>gA", gs.stage_buffer, "Stage Buffer")
            map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
            map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline")
            map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
            map("n", "<leader>gB", function() gs.blame() end, "Blame Buffer")
            map("n", "<leader>gd", gs.diffthis, "Diff This")
            map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
          end,
        }
      '';
    };
    keymaps = [
      {
        key = "<leader>gs";
        action = "<cmd>Neogit kind=floating<cr>";
        options.desc = "Git status";
      }
    ];
  };
}
