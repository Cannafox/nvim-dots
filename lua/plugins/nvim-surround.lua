local M = {"kylechui/nvim-surround"}

M.version = "*"
M.event = "VeryLazy"

function M.opts()
  return {
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  }
end

return { M }
