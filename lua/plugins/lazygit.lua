local M = { "kdheepak/lazygit.nvim" }

M.cmd = {
  "LazyGit",
  "LazyGitConfig",
  "LazyGitCurrentFile",
  "LazyGitFilter",
  "LazyGitFilterCurrentFile",
}

M.keys = {
  { "<leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" }
}

return M
