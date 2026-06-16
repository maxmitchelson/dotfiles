return {
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function(_, opts)
	-- 		require("catppuccin").setup(opts)
	-- 		vim.cmd.colorscheme("catppuccin")
	-- 	end,
	-- 	opts = {
	-- 		flavour = "mocha",
	-- 		integrations = {
	-- 			gitsigns = true,
	-- 			barbar = true,
	-- 			snacks = {
	-- 				enabled = true,
	-- 			},
	-- 			which_key = true,
	-- 		},
	-- 	},
	-- },
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
	-- lazy.nvim
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				theme = "dragon",
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
				background = { dark = "dragon", light = "lotus" },
				overrides = function(colors)
					local theme = colors.theme
					local palette = colors.palette
					return {
						-- === barbar ===
						BufferTabpageFill = { fg = theme.ui.bg_m3, bg = theme.ui.bg_m3 },
						-- active buffer: bright fg on the editor bg
						BufferCurrent = { fg = theme.ui.fg, bg = theme.ui.bg },
						BufferCurrentIndex = { fg = theme.ui.fg, bg = theme.ui.bg },
						BufferCurrentMod = { fg = theme.diag.warning, bg = theme.ui.bg },
						BufferCurrentSign = { fg = theme.syn.fun, bg = theme.ui.bg },
						BufferCurrentTarget = { fg = theme.syn.special2, bg = theme.ui.bg, bold = true },
						-- visible in another window
						BufferVisible = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
						BufferVisibleMod = { fg = theme.diag.warning, bg = theme.ui.bg_m1 },
						BufferVisibleSign = { fg = theme.ui.nontext, bg = theme.ui.bg_m1 },
						BufferVisibleTarget = { fg = theme.syn.special2, bg = theme.ui.bg_m1, bold = true },
						-- inactive
						BufferInactive = { fg = theme.ui.nontext, bg = theme.ui.bg_m3 },
						BufferInactiveMod = { fg = theme.diag.warning, bg = theme.ui.bg_m3 },
						BufferInactiveSign = { fg = theme.ui.bg_p2, bg = theme.ui.bg_m3 },
						BufferInactiveTarget = { fg = theme.syn.special2, bg = theme.ui.bg_m3, bold = true },
					}
				end,
			})
			vim.cmd("colorscheme kanagawa-dragon")
		end,
	},
}
