return {
	{
		"romgrk/barbar.nvim",
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			animation = false,
			sidebar_filetypes = {
				["neo-tree"] = { event = "BufWipeout" },
			},
		},
	},
}
