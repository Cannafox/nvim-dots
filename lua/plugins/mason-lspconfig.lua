local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    automatic_installation = true,
    ensure_installed = {
      "lua_ls",
      "groovyls",
      "marksman",
      "pylsp",
      "jsonls",
      "bashls",
      "clangd",
      "cmake",
      "diagnosticls",
      "dockerls",
      "dotls",
      "yamlls",
      "vimls",
    }
  },
  config = function(_, opts)
    require("mason-lspconfig").setup(opts)
  end
}

return { M }
