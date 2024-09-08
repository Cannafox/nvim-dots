local highlight = {
  "RainbowRed", "RainbowYellow", "RainbowBlue",
  "RainbowOrange", "RainbowGreen", "RainbowViolet",
  "RainbowCyan"
}
return {
    { "nvim-lua/plenary.nvim" },
    { "ryanoasis/vim-devicons" },
    { 'norcalli/nvim-colorizer.lua' },
    { "echasnovski/mini.icons", version = false },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost",
        dependencies = { "HiPhish/rainbow-delimiters.nvim" },
        opts = function()
          return require("configs.indent_blankline")
        end,
        config = function(_, opts)
            vim.g.rainbow_delimiters = { highlight = highlight }
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
            require("ibl").setup(opts)
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        opts = function()
          return require("configs.nvimtree")
        end
    }
}
