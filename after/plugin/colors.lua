vim.opt.termguicolors = true
vim.cmd.colorscheme "catppuccin"

-- Transparent background:
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
