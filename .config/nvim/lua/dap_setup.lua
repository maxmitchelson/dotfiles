local dap = require("dap")
local dapui = require("dapui")
local dapgo = require("dap-go")

dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-dap",
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
	{
		name = "Attach",
		type = "lldb",
		request = "attach",
		program = function()
			return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	    waitFor = true,
		args = {},
	},
}

-- Key mappings
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>B", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Define signs for breakpoints
vim.fn.sign_define("DapBreakpoint", {
	text = "●", -- Red dot character
	texthl = "DapBreakpoint",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapBreakpointCondition", {
	text = "◆", -- Diamond for conditional breakpoints
	texthl = "DapBreakpointCondition",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapBreakpointRejected", {
	text = "○", -- Hollow circle for rejected
	texthl = "DapBreakpointRejected",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapStopped", {
	text = "→", -- Arrow for current line
	texthl = "DapStopped",
	linehl = "DapStoppedLine",
	numhl = "",
})

vim.fn.sign_define("DapLogPoint", {
	text = "◎", -- Double circle for log points
	texthl = "DapLogPoint",
	linehl = "",
	numhl = "",
})

-- Set colors for the signs
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" }) -- Bright red
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f1fa8c" }) -- Yellow
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#808080" }) -- Gray
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00ff00" }) -- Green
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" }) -- Blue

dapgo.setup()
