return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = {'nvim-tree/nvim-web-devicons', 'echasnovski/mini.icons'},
    config = function(_, opts)
        require("bufferline").setup(opts)
        -- Fix bufferline when restoring a session
        vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
          callback = function()
            vim.schedule(function()
              pcall(bufnr)
            end)
          end,
        })
    end,
}
