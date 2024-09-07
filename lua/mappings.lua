vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Explorator
vim.keymap.set("n", "\\", vim.cmd.NvimTreeToggle)

-- Dashboard 
vim.keymap.set("n", "|", ":Dashboard<CR>")

-- Easy terminal escape
vim.keymap.set('t', '<Esc>', "<C-\\><C-n>")

-- Move lines 
vim.keymap.set('v', '<S-Down>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<S-Up>', ":m '<-2<CR>gv=gv")



