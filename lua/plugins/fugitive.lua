return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local fugitive_group = vim.api.nvim_create_augroup("fugitive_group", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = fugitive_group,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                -- git push
                vim.keymap.set("n", "<leader>gp", function()
                    vim.cmd.Git('push')
                end, { buffer = bufnr, remap = false, desc = "Git push" })

                -- git status
                vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { buffer = bufnr, remap = false, desc = "Git push" })
                -- git add all
                vim.keymap.set("n", "<leader>ga", function()
                    vim.cmd.Git({'add',  '--', '.'})
                end, { buffer = bufnr, remap = false, desc = "Git push" })
                -- git add current
                vim.keymap.set("n", "<leader>gA", function()
                    vim.cmd.Git({'add',  vim.fn.expand('%:p')})
                end, { buffer = bufnr, remap = false, desc = "Git push" })
                -- rebase always
                vim.keymap.set("n", "<leader>gl", function()
                    vim.cmd.Git({'pull',  '--rebase'})
                end, { buffer = bufnr, remap = false, desc = "Git push" })

                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>gP", ":Git push -u origin ", { buffer = bufnr, remap = false, desc = "Git push" })
            end,
        })
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end
}
