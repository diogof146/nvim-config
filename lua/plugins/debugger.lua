-- Complete debugger configuration for Python, Lua, Java and JavaScript
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Python configuration
		require("dap-python").setup("/opt/homebrew/bin/python3")
		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = function()
					return "/opt/homebrew/bin/python3"
				end,
			},
		}

		-- Lua configuration
		dap.adapters.nlua = {
			args = { vim.fn.expand("~/one-small-step-for-vimkind/lua/osv.lua") },
			type = "server",
			host = "127.0.0.1",
			port = 8086,
			executable = {
				command = "lua-debug",
			},
		}
		dap.configurations.lua = {
			{
				type = "nlua",
				request = "attach",
				name = "Attach to running Neovim instance",
			},
		}

		-- Java configuration
		dap.adapters.java = function(callback)
			callback({
				{ vim.fn.expand("~/vscode-node-debug2/out/src/nodeDebug.js") },
				type = "server",
				host = "127.0.0.1",
				port = 5005,
			})
		end
		dap.configurations.java = {
			{
				type = "java",
				request = "launch",
				name = "Launch Java Program",
				program = "${file}",
				projectName = "${workspaceFolder}",
			},
		}

		-- JavaScript configuration
		dap.adapters.node2 = {
			type = "executable",
			command = "node",
			args = { vim.fn.expand("~/vscode-node-debug2/out/src/nodeDebug.js") },
		}
		dap.configurations.javascript = {
			{
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
			},
		}

		-- UI Configuration
		require("dapui").setup()

		-- UI Event Handlers
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Keymaps
		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>dc", dap.continue, {})
	end,
}

-- Requirements for each debugger:
--
-- Python
--
--
-- Mason install: debugpy
-- Python3 installed
--
--
-- Lua
--
--
-- Clone: https://github.com/jbyuki/one-small-step-for-vimkind
--
--
-- Java
--
--
-- Mason install: java-debug-adapter, jdtls
-- JDK installed
--
--
-- JavaScript
--
--
-- Clone: https://github.com/microsoft/vscode-node-debug2
-- Run: npm install && npm run build
-- Node.js installed
