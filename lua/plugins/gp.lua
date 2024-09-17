local M = {
	"robitx/gp.nvim",
  opts = {
    openai_api_key = { "cat", "/home/gklodkox/.config/openai.token" }
  },
	config = function(_, opts)
		require("gp").setup(opts)
	end,
}

return { M }
