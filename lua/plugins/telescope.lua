return {
    'nvim-telescope/telescope.nvim'
    , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "Find files"})
        vim.keymap.set('n', '<leader>b', builtin.buffers, {desc = "Show buffers"})
        vim.keymap.set('n', '<leader>gf', builtin.git_files, {desc = "Find git files"})
        vim.keymap.set('n', '<leader>fw', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, {desc = "Grep word under cursor"})
        vim.keymap.set('n', '<leader>fg', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, {desc = "File grep in cwd"})
        vim.keymap.set('n', '<leader>ht', builtin.help_tags, {desc = "Show help tags"})
    end
}
