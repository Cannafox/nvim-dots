return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "vimdoc", "c", "lua", "rust",
                "jsdoc", "bash", "vim", "query", "markdown",
                "markdown_inline", "python", "cpp", "fish"
            },
            sync_install = false,
            ignore_install = {""},
            highlight = {
                enable = true,
                disable = {""},
                additional_vim_regex_highlighting = true,
            },
            indent = { enable = true },
        })

        -- local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        -- treesitter_parser_config.templ = {
        --     install_info = {
        --         url = "https://github.com/vrischmann/tree-sitter-templ.git",
        --         files = {"src/parser.c", "src/scanner.c"},
        --         branch = "master",
        --     },
        -- }

        -- vim.treesitter.language.register("templ", "templ")
    end
}
