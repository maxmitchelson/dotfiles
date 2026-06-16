-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Font support
vim.g.have_nerd_font = false

-- Numbering
vim.o.number = true
vim.o.relativenumber = true

-- Cursor
vim.o.cursorline = true
vim.o.scrolloff = 10

-- Enable mouse
vim.o.mouse = "a"

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching unless there's a capital letter or \C in the search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Preview substitutions live
vim.o.inccommand = "split"

-- Always show the column for symbols alongside the line number column
-- (Default is to only show it when there are symbols)
vim.o.signcolumn = "yes"

vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Sets where new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- Tabulation
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 0 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

-- No text wrap by default
vim.opt.wrap = false

-- Disable built-in mode indicator (in favor of custom bar)
vim.o.showmode = false
vim.o.laststatus = 3

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
