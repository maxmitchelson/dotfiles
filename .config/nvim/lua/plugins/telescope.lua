return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				-- Stick to Telescope defaults; only wire up fzf for speed.
			})
			pcall(telescope.load_extension, "fzf")
		end,
		keys = {
			-- Top
			{
				"<leader><space>",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>,",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>/",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>:",
				function()
					require("telescope.builtin").command_history()
				end,
				desc = "Command History",
			},
			-- find
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fc",
				function()
					require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>fr",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "Recent",
			},
			-- git
			{
				"<leader>gb",
				function()
					require("telescope.builtin").git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>gl",
				function()
					require("telescope.builtin").git_commits()
				end,
				desc = "Git Log",
			},
			{
				"<leader>gs",
				function()
					require("telescope.builtin").git_status()
				end,
				desc = "Git Status",
			},
			{
				"<leader>gS",
				function()
					require("telescope.builtin").git_stash()
				end,
				desc = "Git Stash",
			},
			{
				"<leader>gf",
				function()
					require("telescope.builtin").git_bcommits()
				end,
				desc = "Git Log File",
			},
			-- search
			{
				"<leader>sb",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sB",
				function()
					require("telescope.builtin").live_grep({ grep_open_files = true })
				end,
				desc = "Grep Open Buffers",
			},
			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>sw",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			{
				'<leader>s"',
				function()
					require("telescope.builtin").registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>s/",
				function()
					require("telescope.builtin").search_history()
				end,
				desc = "Search History",
			},
			{
				"<leader>sa",
				function()
					require("telescope.builtin").autocommands()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sc",
				function()
					require("telescope.builtin").command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
				function()
					require("telescope.builtin").commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>sD",
				function()
					require("telescope.builtin").diagnostics({ bufnr = 0 })
				end,
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>sh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>sH",
				function()
					require("telescope.builtin").highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>sj",
				function()
					require("telescope.builtin").jumplist()
				end,
				desc = "Jumps",
			},
			{
				"<leader>sk",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sl",
				function()
					require("telescope.builtin").loclist()
				end,
				desc = "Location List",
			},
			{
				"<leader>sm",
				function()
					require("telescope.builtin").marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>sM",
				function()
					require("telescope.builtin").man_pages()
				end,
				desc = "Man Pages",
			},
			{
				"<leader>sq",
				function()
					require("telescope.builtin").quickfix()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sR",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Resume",
			},
			{
				"<leader>st",
				"<cmd>TodoTelescope<cr>",
				desc = "TODO",
			},
			{
				"<leader>uC",
				function()
					require("telescope.builtin").colorscheme()
				end,
				desc = "Colorschemes",
			},
			-- LSP
			{
				"gd",
				function()
					require("telescope.builtin").lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"gD",
				vim.lsp.buf.declaration,
				desc = "Goto Declaration",
			},
			{
				"gr",
				function()
					require("telescope.builtin").lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gI",
				function()
					require("telescope.builtin").lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"gy",
				function()
					require("telescope.builtin").lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			{
				"<leader>ss",
				function()
					require("telescope.builtin").lsp_document_symbols()
				end,
				desc = "LSP Symbols",
			},
			{
				"<leader>sS",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},
		},
	},
}
