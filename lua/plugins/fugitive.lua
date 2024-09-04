local get_current_branch = function()
  local cmdline = "git rev-parse --abbrev-ref HEAD"
  local branch = vim.fn.system(cmdline):gsub("\n", "")
  return branch
end

vim.api.nvim_set_keymap("n", "<leader>gcB", ":Git checkout -b ", {desc = "Git checkout to new branch", noremap = true, silent = false})
vim.api.nvim_set_keymap("n", "<leader>gcm", ":Git commit -m ", {desc = "Git commit", silent = false, noremap = true})
return {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      {"<leader>gss", "<cmd>Git status<cr>", desc = "Git status"},
      {"<leader>gl", "<cmd>Git pull --rebase<cr>", desc = "Git pull (rebase)"},
      {"<leader>gp", "<cmd>Git push<cr>", desc = "Git push"},
      {"<leader>gP", "<cmd>Git push -u origin "..get_current_branch().."<cr>", desc = "Git push (set origin)"},
      {"<leader>ga", "<cmd>Git add .<cr>", desc = "Git add all"},
      {"<leader>gA", "<cmd>Git add %<cr>", desc = "Git add current_file"},
      {"<leader>gsb", "<cmd>echo '"..get_current_branch().."'<cr>", desc = "Git show current branch"},
      {"<leader>gcb", "<cmd>Telescope git_branches<cr>", desc = "Git checkout to existing branch"},
      {"<leader>gcM", "<cmd>Git commit --allow-empty -m 'Reset CI'<cr>", desc = "Git commit (empty)"},

    }
    --     vim.keymap.set("n", "<leader>gd", "<cmd>diffget //2<CR>", { buffer = bufnr, remap = false, desc = "Git diff 2" })
    --     vim.keymap.set("n", "<leader>gD", "<cmd>diffget //3<CR>", { buffer = bufnr, remap = false, desc = "Git diff 3" })
    -- end,
}
