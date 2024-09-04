return {
  'nvim-telescope/telescope.nvim'
  ,
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  init = function()
    vim.g.lazyvim_picker = "telescope"
  end,
  config = function()
    require('telescope').setup({})
    local builtin = require('telescope.builtin')
    -- local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")

    local live_grep_from_git_cwd = function()
      local is_git_repo = function()
        vim.fn.system("git rev-parse --is-inside-work-tree")

        return vim.v.shell_error == 0
      end
      local get_git_root = function()
        local git_repo_path = vim.fn.finddir(".git", ".;")

        return vim.fn.fnamemodify(git_repo_path, ":h")
      end
      local opts = {}
      if is_git_repo() then
        opts = { cwd = get_git_root() }
      end

      require("telescope.builtin").live_grep(opts)
    end

    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Show buffers" })
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = "Find git files" })
    vim.keymap.set('n', '<leader>fw', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end, { desc = "Grep word under cursor" })
    vim.keymap.set('n', '<leader>fg', live_grep_from_git_cwd, { desc = "Grep files" })
    vim.keymap.set('n', '<leader>ht', builtin.help_tags, { desc = "Show help tags" })
  end
}
