local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-calc",
    {"mtoohey31/cmp-fish", ft = "fish"},
    {"vrslev/cmp-pypi", ft = "toml"},
    "petertriho/cmp-git",
    "hrsh7th/cmp-cmdline",
    "lukas-reineke/cmp-rg",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
    },
    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)

        -- setup cmp for autopairs
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    {"doxnit/cmp-luasnip-choice", config = function() require('cmp_luasnip_choice').setup({ auto_open = true }) end},
    "saadparwaiz1/cmp_luasnip",
    "ray-x/cmp-treesitter",
  },
  init = function()
    vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
  end,
  config = function()
    -- vim.fn.sign_define('DiagnosticSignError', {texthl = "DiagnosticSignError", text = "✘", numhl = ''})
    -- vim.fn.sign_define('DiagnosticSignWarn', {texthl = "DiagnosticSignWarn", text = "▲", numhl = ''})
    -- vim.fn.sign_define('DiagnosticSignHint', {texthl = "DiagnosticSignHint", text = "⚑", numhl = ''})
    -- vim.fn.sign_define('DiagnosticSignInfo', {texthl = "DiagnosticSignInfo", text = "", numhl = ''})
    vim.diagnostic.config({
      virtual_text = false,
      severity_sort = true,
      float = {
        border = 'rounded',
        source = 'if_many',
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '✘',
          [vim.diagnostic.severity.WARN] = '▲',
          [vim.diagnostic.severity.INFO] = '⚑',
          [vim.diagnostic.severity.HINT] = '',
        },
      }
    })
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
      vim.lsp.handlers.hover,
      {border = 'rounded'}
    )
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      {border = 'rounded'}
    )

    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local luasnip = require("luasnip")

    require('luasnip.loaders.from_vscode').lazy_load()
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      formatting = {
        fields = {'menu', 'abbr', 'kind'},
        expandable_indicator = true,
        format = lspkind.cmp_format({
          mode = 'symbol_text', -- show only symbol annotations
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        })
      },
      sources = cmp.config.sources({
        {name = 'nvim_lsp', keyword_length = 1},
        {name = 'luasnip', keyword_length = 2},
        {name = 'luasnip_choice', keyword_length = 2},
        {name = 'path'},
        {name = 'calc'},
        {name = 'git'},
        {name = 'treesitter'},
        {name = 'nvim_lsp_signature_help'},
        {name = 'pypi', keyword_length = 4},
        {name = 'fish', option = { fish_path = "/usr/bin/fish" }},
        {name = 'rg', keyword_length = 3},
        {name = 'buffer', keyword_length = 3},
      }),
      mapping = cmp.mapping.preset.insert({
        ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<Down>'] = cmp.mapping.select_next_item(cmp_select),

        ['<C-Up>'] = cmp.mapping.scroll_docs(-4),
        ['<C-Down>'] = cmp.mapping.scroll_docs(4),

        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({select = true, behavior = cmp.ConfirmBehavior.Insert}),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {'i', 's'})
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })
    require("cmp_git").setup()
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = "git" },
      }, {
        { name = "buffer" },
      })
    })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }
      }
    })
    cmp.setup.cmdline({ '/' }, {
      sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" }
      }, {
        { name = "buffer" }
      }),
    })
    cmp.setup.cmdline({ ':' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" }
      }, {
        { name = "cmdline" }
      }),
      -- matching = { disallow_symbol_nonprefix_matching = false }
    })
  end
}

return { M }
