local M = { "j-hui/fidget.nvim" }

M.opts = {
  notification = {
    poll_rate = 10,
    history_size = 512,
    override_vim_notify = true,
    window = {
      winblend = 0
    }
  },
}

return M
