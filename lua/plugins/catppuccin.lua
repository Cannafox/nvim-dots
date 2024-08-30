return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "mocha",
        integrations = {
            cmp = true, 
            gitsigns = true,
            nvimtree = true, 
            treesitter = true, 
            notify = true,
            dashboard = true, 
            indent_blankline = true,
            mason = true, 
            noice = true,
            telescope = true,
            lsp_trouble = true,
            which_key = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                    ok = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                    ok = { "underline" },
                },
                inlay_hints = {
                    background = true,
                },
            },
        },
    }
}
