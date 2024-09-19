local M  = {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    auto_update = true,
    ensure_installed = {
      "stylua",
      "prettier",
      "isort",
      "black",
      "pylint",
      "eslint_d",
      "shellcheck",
      "editorconfig-checker",
      "autopep8",
      "cmakelang",
      "clang-format",
      "markdownlint",
      "npm-groovy-lint",
      "jsonnetfmt",
      "yamlfmt",
      "codespell",
      "cpplint",
    },
    integrations = {
      ['mason-lspconfig'] = true
    }
  },
  -- config = function(_, opts)
  --   require("mason-tool-installer").setup(opts)
  -- end
}

return { M }
