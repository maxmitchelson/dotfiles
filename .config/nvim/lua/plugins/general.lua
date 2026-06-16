return {
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 200,
			icons = {
				mappings = true,
			},
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>f", group = "[F]ind" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>g", group = "[G]it" },
			},
			plugins = {
				registers = false,
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {},
	},
	{ -- might not seem like it, but this is actually worth having, better than mini.autopairs too
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Better arround/inside selection
			require("mini.ai").setup({ n_lines = 500 })
			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			require("mini.surround").setup()
			-- Move lines and blocks
			require("mini.move").setup()

			-- Simple and easy statusline.
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = true })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
}
