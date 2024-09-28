local M = {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  cmd = "Telescope",
  dependencies = {
      'nvim-treesitter/nvim-treesitter',
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-dap.nvim",
  },
  opts = {
    defaults = {
      prompt_prefix = "   ",
      selection_caret = " ",
      entry_prefix = " ",
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
      },
      mappings = {
        n = {
          ["q"] = require("telescope.actions").close,
        },
      },
    },
    extensions_list = { "ui-select", "frecency", "project", "live_grep_args", "dap" },
    extensions = {},
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup(opts)

    for _, extension in ipairs(opts.extensions_list) do
      telescope.load_extension(extension)
    end

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
    vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, { desc = "Grep files" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Search buffers" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Search help tags" })
  end
}

return { M }
