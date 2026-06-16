-- Rebind S
vim.keymap.set("n", "s", "cl", { noremap = true })
vim.keymap.set("v", "s", "c", { noremap = true })
-- Disable movement with arrow keys
vim.keymap.set("n", "<left>", "<Nop>")
vim.keymap.set("n", "<right>", "<Nop>")
vim.keymap.set("n", "<up>", "<Nop>")
vim.keymap.set("n", "<down>", "<Nop>")

-- Naviagate between splits using Ctrl+h,j,k,l
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left buffer" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right buffer" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower buffer" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper buffer" })

-- Move splits using Ctrl+Shift+h,j,k,l
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move buffer left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move buffer right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move buffer down" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move buffer up" })

-- Clear search highlights on <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnositc
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostics" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to Location List" })

-- LSP actions
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

-- Toggle Wrap
vim.keymap.set("n", "<leader>tw", function()
	vim.opt_local.wrap = not vim.opt_local.wrap:get()
end, { desc = "[T]oggle line [w]rap" })

-- Tabs Move/Reorder/Close
local opts = { }
vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
vim.keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
vim.keymap.set("n", "<A-q>", "<Cmd>BufferClose<CR>", opts)

-- Indent in Visual Mode
vim.keymap.set("v", "<Tab>", ">gv", { silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true })
-- vim.keymap.set("n", "<Tab>", ">>", { silent = true })
-- vim.keymap.set("n", "<S-Tab>", "<<", { silent = true })

-- Enable <Ctrl + I> for "redo" cursor, otherwise it simply indents
vim.keymap.set("n", "<C-i>", "<C-i>", { silent = true, noremap = true })

-- U for redo
vim.keymap.set("n", "U", "<C-r>", { silent = true })
