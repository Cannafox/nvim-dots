local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag" },
  opts = {
    ensure_installed = {
      "vimdoc", "c", "lua", "rust",
      "jsdoc", "bash", "vim", "query", "markdown",
      "markdown_inline", "python", "cpp", "fish"
    },
    sync_install = false,
    ignore_install = {""},
    highlight = { enable =  true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    autotag = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  },
  config = function(_, opts)
    local configs = require("nvim-treesitter.configs")

    configs.setup(opts)
  end
}

return { M }
