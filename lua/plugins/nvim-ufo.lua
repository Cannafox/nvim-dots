return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    init = function()
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      local ufo = require("ufo")
      vim.keymap.set('n', 'zR', ufo.openAllFolds, {desc = "Open all folds"})
      vim.keymap.set('n', 'zM', ufo.closeAllFolds, {desc = "Close all folds"})
    end

  }
}
