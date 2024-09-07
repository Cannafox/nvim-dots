-- Keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(client, bufnr)
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap("n", "<leader>F", function() vim.lsp.buf.format {async = true } end)

    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        local float_opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded",
          source = "always", -- show source in diagnostic popup window
          prefix = " ",
        }

        if not vim.b.diagnostics_pos then
          vim.b.diagnostics_pos = { nil, nil }
        end

        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
            and #vim.diagnostic.get() > 0
        then
          vim.diagnostic.open_float(nil, float_opts)
        end

        vim.b.diagnostics_pos = cursor_pos
      end,
    })

    if vim.g.logging_level == "debug" then
      local msg = string.format("Language server %s started!", client.name)
      vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
    end
  end
})
-- -- LSP signs
-- local sign = function(opts)
--   vim.fn.sign_define(opts.name, {
--     texthl = opts.name,
--     text = opts.text,
--     numhl = ''
--   })
-- end
-- sign({name = 'DiagnosticSignError', text = ''})
-- sign({name = 'DiagnosticSignWarn', text = ''})
-- sign({name = 'DiagnosticSignHint', text = ''})
-- sign({name = 'DiagnosticSignInfo', text = ''})


return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-calc",
        {"mtoohey31/cmp-fish", ft = "fish"},
        {"vrslev/cmp-pypi", ft = "toml"},
        "petertriho/cmp-git",
        "hrsh7th/cmp-cmdline",
        "lukas-reineke/cmp-rg",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        {"doxnit/cmp-luasnip-choice", config = function() require('cmp_luasnip_choice').setup({ auto_open = true }) end},
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
        "ray-x/cmp-treesitter",
    },
    config = function()
        local cmp_lsp = require("cmp_nvim_lsp")
        local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
        cmp_lsp_capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }
        local lsp_capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp_capabilities
        )

        require("mason").setup()
        require("mason-lspconfig").setup({
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
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = lsp_capabilities
                    }
                end,

                ["lua_ls"] = function()
                  local lspconfig = require("lspconfig")
                  lspconfig.lua_ls.setup {
                    on_init = function(client)
                      local path = client.workspace_folders[1].name
                      if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                        return
                      end
                      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        workspace = {
                          checkThirdParty = false,
                          library = {
                            vim.env.VIMRUNTIME
                          }
                        }
                      })
                      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                      return true
                    end,
                    settings = {
                      Lua = {
                        runtime = { version = "LuaJIT" }
                      }
                    },
                    capabilities = lsp_capabilities
                  }
                end,
                ["pylsp"] = function()
                    local lspconfig = require("lspconfig")
                    local venv_path = os.getenv('VIRTUAL_ENV')
                    local py_path = nil
                    if venv_path ~= nil then
                      py_path = venv_path .. "/bin/python3"
                    else
                      py_path = vim.g.python3_host_prog
                    end
                    lspconfig.pylsp.setup {
                        settings = {
                          pylsp = {
                            plugins = {
                              -- formatter
                              black = { enabled = true },
                              pylint = { enabled = true, executable = "pylint" },
                              ruff = { enabled = false },
                              pylsp_mypy = {
                                enabled = true,
                                overrides = { "--python-executable", py_path, true },
                                report_progress = true,
                                live_mode = false
                              },
                              pycodestyle = {
                                ignore = {'W391'},
                                maxLineLength = 100
                              },
                              isort = { enabled = true },
                            }
                          }
                        },
                        capabilities = lsp_capabilities
                    }
                end,
                ["groovyls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.groovyls.setup {
                        filetypes = {'groovy'},
                        cmd = { "java", "-jar", "/home/gklodkox/sources/groovy-language-server/build/libs/groovy-language-server-all.jar" },
                        capabilities = lsp_capabilities,
                        settings = {
                          groovy = {
                            classpath = {
                              vim.fn.expand("%"),
                              string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
                            }
                          }
                        }
                    }
                end,
                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                        filetypes = {"c", "cpp", "cc"},
                        capabilities = lsp_capabilities
                    }
                end,
                ["bashls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.bashls.setup {
                        capabilities = lsp_capabilities
                    }
                end,
                ["vimls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.vimls.setup {
                        capabilities = lsp_capabilities
                    }
                end,
                ["dockerls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.dockerls.setup {
                        settings = {
                            docker = {
                                languageserver = {
                                    formatter = {
                                        ignoreMultilineInstructions = true,
                                    },
                                },
                            }
                        },
                        capabilities = lsp_capabilities
                    }
                end,
            }
        })
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local handlers = require('nvim-autopairs.completion.handlers')
        local cmp = require('cmp')
        local ufo = require("ufo").setup()
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local lspkind = require("lspkind")

        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done({
            filetypes = {
              -- "*" is a alias to all filetypes
              ["*"] = {
                ["("] = {
                  kind = {
                    cmp.lsp.CompletionItemKind.Function,
                    cmp.lsp.CompletionItemKind.Method,
                  },
                  handler = handlers["*"]
                }
              },
              lua = {
                ["("] = {
                  kind = {
                    cmp.lsp.CompletionItemKind.Function,
                    cmp.lsp.CompletionItemKind.Method
                  },
                  ---@param char string
                  ---@param item table item completion
                  ---@param bufnr number buffer number
                  ---@param rules table
                  ---@param commit_character table<string>
                  handler = function(char, item, bufnr, rules, commit_character)
                    -- Your handler function. Inspect with print(vim.inspect{char, item, bufnr, rules, commit_character})
                  end
                }
              },
              -- Disable for tex
              tex = false
            }
          })
        )

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-Enter>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Esc>"] = cmp.mapping.close(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
                { name = 'luasnip_choice' }, -- For luasnip users.
                { name = 'calc' },
                { name = 'path' },
                { name = 'buffer', keyword_length = 2 },
                { name = 'rg', keyword_length = 3 },
                { name = 'git' },
                { name = 'treesitter' },
                { name = 'pypi', keyword_length = 4 },
                { name = 'fish', option = { fish_path = "/usr/bin/fish"} },
                { name = "nvim_lsp_signature_help" },
            }),
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    show_labelDetails = true,
                    before = function (_, vim_item)
                        return vim_item
                    end
                })
            },
        })
        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = "git" },
          }, {
            { name = "buffer" },
          })
        })
        require("cmp_git").setup()
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
          matching = { disallow_symbol_nonprefix_matching = false }
        })
        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })
        require("cmp_git").setup()
    end
}
