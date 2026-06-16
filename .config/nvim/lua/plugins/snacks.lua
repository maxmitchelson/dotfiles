return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			dashboard = {
				sections = {
					{ section = "header" },
					{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
					{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{ section = "startup" },
				},
			},
			explorer = { enabled = false },
			input = { enabled = true },
			picker = { enabled = false },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = false },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
		},
	},
}
