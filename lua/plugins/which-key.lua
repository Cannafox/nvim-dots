local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    icons = {
      mappings = false
    }
  },
  config = function(_, opts)
    require("which-key").setup(opts)
  end
}

return { M }
