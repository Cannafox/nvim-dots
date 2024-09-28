local M = { "folke/lsp-colors.nvim" }

M.opts = {
  Error = "#FF10F0",
  Warning = "#FFC300",
  Hint = "#DAF7A6",
  Information = "#5BCEFA",
}

M.config = function(_, opts)
  require("lsp-colors").setup(opts)
end

return { M }
