local M = {
	"stevearc/conform.nvim",
	event = "User FilePost",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			["*"] = { "codespell" },
			["_"] = { "trim_whitespace" },
		},
		format_on_save = false,
	},
	config = function(_, opts)
		conform = require("conform")

		conform.setup(opts)

		vim.keymap.set("n", "<leader>F", function()
			conform.format({ bufnr = vim.api.nvim_get_current_buf() })
		end, { desc = "Format current buffer" })
	end,
}

return { M }
