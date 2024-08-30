return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "groovyls",
                "marksman",
                "pylsp",
                "pyright",
                "jsonls",
                "bashls",
                "clangd",
                "cmake",
                "diagnosticls",
                "dockerls",
                "dotls",
                "yamlls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                      local lspconfig = require("lspconfig")
                      lspconfig.lua_ls.setup {
                          on_init = function(client)
                              local path = client.workspace_folders[1].name
                              if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                                return
                              end
                              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                                    runtime = {
                                        version = 'LuaJIT'
                                    },
                                    -- Make the server aware of Neovim runtime files
                                    workspace = {
                                      checkThirdParty = false,
                                      library = {
                                        vim.env.VIMRUNTIME
                                      }
                                    }
                              })
                          end,
                          settings = {
                            Lua = {}
                          }
                      }
                end,
                ["pylsp"] = function()
                    local lspconfig = require("lspconfig")                    
                    lspconfig.pylsp.setup {
                        settings = {
                          pylsp = {
                            plugins = {
                              pycodestyle = {
                                ignore = {'W391'},
                                maxLineLength = 100
                              }
                            }
                          }
                        }
                    }
                end,
                ["groovyls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.groovyls.setup {
                        cmd = { "java", "-jar", "~/sources/groovy-language-server/build/libs/groovy-language-server.jar" }
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
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
