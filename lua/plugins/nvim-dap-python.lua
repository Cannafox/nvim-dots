local M = {
	'mfussenegger/nvim-dap-python',
	config = function ()
		require("dap-python").setup(vim.g.python3_host_prog)
	end
}

return { M }
