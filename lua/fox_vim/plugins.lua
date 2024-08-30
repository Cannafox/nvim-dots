vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  use({
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  })

  use({ "catppuccin/nvim", as = "catppuccin" })   
  
  use({ "nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"} })
  use({ "nvim-treesitter/playground" })

  use({ "ThePrimeagen/harpoon" })
  use({ "mbbill/undotree" })

  use({ "tpope/vim-fugitive" })

  use({
    "VonHeikemen/lsp-zero.nvim", branch = "v4.x",
    requires = {
      -- LSP Support
      {"neovim/nvim-lspconfig"},
      {"williamboman/mason.nvim"},
      {"williamboman/mason-lspconfig.nvim"},

      -- Autocompletion
      {"hrsh7th/nvim-cmp"},
      {"hrsh7th/cmp-buffer"},
      {"hrsh7th/cmp-path"},
      {"saadparwaiz1/cmp_luasnip"},
      {"hrsh7th/cmp-nvim-lsp"},
      {"hrsh7th/cmp-nvim-lua"},
      {"L3MON4D3/LuaSnip"},
      {"rafamadriz/friendly-snippets"},
    }
  })

end)
