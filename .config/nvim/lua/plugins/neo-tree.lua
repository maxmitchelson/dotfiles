return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		opts = {
			close_if_last_window = true,
			window = {
				width = 32,
			},
			filesystem = {
				hijack_netrw_behavior = "open_default",
				follow_current_file = { enabled = true },
				filtered_items = {
					show_hidden_count = false,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = { "node_modules" },
					never_show = { ".git" },
				},
			},
		},
		keys = {
			{
				"<C-n>",
				"<cmd>Neotree toggle reveal<cr>",
				desc = "File Explorer",
			},
		},
	},
}
