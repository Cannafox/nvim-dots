local M = {
  "j-hui/fidget.nvim",
  opts = {
    notification = {
      poll_rate = 10,
      filter = vim.log.levels.INFO,
      history_size = 512,
      override_vim_notify = true,
      window = {
        winblend = 0
      }
    },
  },
}

return { M }
