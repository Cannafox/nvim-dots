local M = { "LunarVim/bigfile.nvim" }

function M.opts()
  return {
    filesize = 2,
    pattern = { "*" },
    features = {
      "indent_blankline",
      "illuminate",
      "lsp",
      "treesitter",
      "syntax",
      "matchparen",
      "vimopts",
      "filetype",
    }
  }
end

return M
