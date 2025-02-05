-- Terminal Integration for Neovim

return {
	"akinsho/toggleterm.nvim", -- Plugin repository (GitHub: akinsho/toggleterm.nvim)
	version = "*", -- Use the latest available version
	config = function()
		-- Core state management
		local terminal_state = {
			last_position = nil, -- Tracks the cursor position in the terminal for restore after exiting
		}

		-- Function to detect project type by checking for specific configuration files (e.g., pom.xml, build.gradle)
		local function detect_project_type()
			local files = vim.fn.glob(vim.fn.getcwd() .. "/*", true, true) -- Scans the current directory
			return {
				has_pom = vim.tbl_contains(files, vim.fn.getcwd() .. "/pom.xml"), -- Checks for pom.xml (Maven project)
				has_gradle = vim.tbl_contains(files, vim.fn.getcwd() .. "/build.gradle"), -- Checks for build.gradle (Gradle project)
			}
		end

		-- Generates language-specific run commands based on the file type and content
		-- If the file is unsaved, it runs the file content as a script; otherwise, it runs the file directly.
		local function get_run_command(filename, filetype)
			local project_info = detect_project_type() -- Detect if the project uses Maven or Gradle
			local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") -- Get the current buffer's content
			content = content:gsub("'", "'\\''") -- Escape single quotes in content for shell safety
			filename = vim.fn.shellescape(filename) -- Escape the filename for shell compatibility

			-- Define the run commands for different programming languages
			local commands = {
				python = function()
					-- If the file has unsaved changes, run the content as a Python script; otherwise, run the file directly
					return vim.bo.modified and string.format([[python3 -c '%s']], content)
						or string.format("python3 %s", filename)
				end,

				java = function()
					-- Check if the project is a Gradle or Maven project and choose the appropriate run command
					if project_info.has_gradle then
						return "./gradlew run"
					elseif project_info.has_pom then
						return "mvn exec:java"
					else
						local class_name = vim.fn.fnamemodify(filename, ":t:r") -- Get the Java class name
						return vim.bo.modified and string.format([[echo '%s' | java -]], content)
							or string.format("java %s", filename)
					end
				end,

				javascript = function()
					-- Run the JavaScript file with Node.js
					return vim.bo.modified and string.format([[node -e '%s']], content)
						or string.format("node %s", filename)
				end,

				lua = function()
					-- Run the Lua script
					return vim.bo.modified and string.format([[lua -e '%s']], content)
						or string.format("lua %s", filename)
				end,
			}

			return commands[filetype] and commands[filetype]() or nil -- Return the appropriate command based on filetype
		end

		-- Terminal configuration initialization using toggleterm.nvim
		require("toggleterm").setup({
			size = function(term)
				-- Dynamically set the terminal size based on the direction (horizontal or vertical)
				if term.direction == "horizontal" then
					return 15 -- Horizontal terminal size (in lines)
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4 -- Vertical terminal size (as a percentage of the screen width)
				end
			end,

			-- Configuration for floating terminal windows
			float_opts = {
				border = "curved", -- Curved border for a modern look
				width = 180, -- Width of the floating window
				height = 45, -- Height of the floating window
				winblend = 4, -- Transparency of the floating window
			},

			-- Default terminal settings
			direction = "float", -- Use a floating window for the terminal
			close_on_exit = false, -- Keep the terminal open even after the process exits
			auto_scroll = true, -- Automatically scroll the terminal
			shade_terminals = true, -- Shade the terminal background for better contrast
			shade_factor = 2, -- Amount of shading applied to terminal windows
			shell = vim.o.shell, -- Use the default shell specified in Neovim settings
			start_in_insert = true, -- Start in insert mode when the terminal opens
			insert_mappings = true, -- Enable insert mode key mappings for the terminal
			terminal_mappings = true, -- Enable key mappings for the terminal
			persist_size = true, -- Persist terminal size between uses
			persist_mode = true, -- Persist terminal mode (insert/normal)
		})

		-- Main execution function that runs the current file in the terminal
		local function run_file()
			local filetype = vim.bo.filetype -- Get the file type of the current buffer
			local filename = vim.fn.expand("%:p") -- Get the full path of the current file
			local command = get_run_command(filename, filetype) -- Get the appropriate run command

			if not command then
				vim.notify("No run command defined for filetype: " .. filetype, vim.log.levels.ERROR)
				return
			end

			-- Configure and launch the terminal instance to run the file
			local Terminal = require("toggleterm.terminal").Terminal
			local runner = Terminal:new({
				cmd = command, -- The command to run in the terminal
				hidden = true, -- Hide the terminal initially
				direction = "float", -- Open the terminal in floating mode

				on_open = function(term)
					vim.cmd("startinsert!") -- Automatically start in insert mode
					-- Set up terminal keybindings
					local opts = { noremap = true, silent = true, buffer = term.bufnr }
					vim.keymap.set("n", "q", "<cmd>close<CR>", opts) -- Close terminal with 'q'
					vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts) -- Exit terminal insert mode
					vim.keymap.set("t", "<C-v>", '<C-\\><C-n>"+pi', opts) -- Paste from clipboard in terminal
					vim.keymap.set("t", "<C-c>", '<C-\\><C-n>"+yi', opts) -- Copy from terminal to clipboard
					terminal_state.last_position = vim.api.nvim_win_get_cursor(term.window) -- Save cursor position
				end,

				on_exit = function(term, _, exit_code, _)
					if exit_code ~= 0 then
						vim.notify(string.format("Process exited with code %d", exit_code), vim.log.levels.WARN)
					end
					-- Restore cursor position if it was previously saved
					if terminal_state.last_position then
						vim.api.nvim_win_set_cursor(term.window, terminal_state.last_position)
					end
				end,
			})

			runner:toggle() -- Toggle the terminal window
		end

		-- Global keybindings for running files and toggling the terminal
		vim.keymap.set("n", "<F5>", run_file, { noremap = true, silent = true }) -- Map <F5> to run the current file
		vim.keymap.set({ "n", "t" }, "<F6>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true }) -- Map <F6> to toggle terminal visibility
	end,
}
