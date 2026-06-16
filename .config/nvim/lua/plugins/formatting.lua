return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>ft",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = true,
			-- format_on_save = function(bufnr)
			--   local disable_filetypes = {--[[  c = true, cpp = true  ]]
			--   }
			--   return {
			--     timeout_ms = 500,
			--     lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			--   }
			-- end,
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
				cpp = { "clang-format" },
				json = { "prettier" },
				javascript = { "prettier" },
				python = { "autopep8" },
			},
		},
	},
}
