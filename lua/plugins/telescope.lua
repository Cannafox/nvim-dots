return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-telescope/telescope-ui-select.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-telescope/telescope-project.nvim',
            'tsakirist/telescope-lazy.nvim',
            "nvim-telescope/telescope-live-grep-args.nvim",
            'nvim-telescope/telescope-frecency.nvim',
        },
        init = function()
          vim.g.lazyvim_picker = "telescope"
        end,
        config = function ()
            require("telescope").setup()
            require("telescope").load_extension("ui-select")
            require("telescope").load_extension("frecency")
            require("telescope").load_extension("project")
            require("telescope").load_extension("live_grep_args")
        end
    }
}
