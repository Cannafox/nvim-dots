local SymbolKind = vim.lsp.protocol.SymbolKind

local M = {
	"VidocqH/lsp-lens.nvim",
	opts = {
		enable = true,
		include_declaration = false, -- Reference include declaration
		sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
			definition = false,
			references = true,
			implements = true,
			git_authors = true,
		},
		ignore_filetype = {
			"prisma",
		},
		-- Target Symbol Kinds to show lens information
		target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
		-- Symbol Kinds that may have target symbol kinds as children
		wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
	},
  config = function (_, opts)
    require("lsp-lens").setup(opts)
  end
}

return { M }
