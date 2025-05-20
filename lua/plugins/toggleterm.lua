-- Terminal Integration for Neovim - Fixed Java Command Generation

return {
	"akinsho/toggleterm.nvim",
	version = "*", -- Use the latest available version
	config = function()
		-- Core state management
		local terminal_state = {
			last_position = nil, -- Tracks the cursor position in the terminal for restore after exiting
		}

		-- Function to detect project type by checking for specific configuration files
		local function detect_project_type()
			local files = vim.fn.glob(vim.fn.getcwd() .. "/*", true, true) -- Scans the current directory
			return {
				has_pom = vim.tbl_contains(files, vim.fn.getcwd() .. "/pom.xml"), -- Checks for pom.xml (Maven project)
				has_gradle = vim.tbl_contains(files, vim.fn.getcwd() .. "/build.gradle"), -- Checks for build.gradle (Gradle project)
			}
		end

		-- Extracts package name from Java file content
		local function extract_java_package(content)
			-- Look for package declaration in the content
			local package_match = string.match(content, "package%s+([%w%.]+)%s*;")
			return package_match
		end

		-- Detect if file uses Swing, AWT, JavaFX, or JOptionPane
		local function detect_java_ui_frameworks(content)
			return {
				has_swing = string.match(content, "import%s+javax%.swing") ~= nil,
				has_awt = string.match(content, "import%s+java%.awt") ~= nil,
				has_javafx = string.match(content, "import%s+javafx") ~= nil,
				has_optionpane = string.match(content, "JOptionPane") ~= nil
					or string.match(content, "import%s+javax%.swing%.JOptionPane") ~= nil,
			}
		end

		-- Generates language-specific run commands based on the file type and content
		local function get_run_command(filename, filetype)
			local project_info = detect_project_type() -- Detect if the project uses Maven or Gradle
			local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") -- Get the current buffer's content

			-- We'll properly escape the filename differently for each command type
			local plain_filename = vim.fn.expand("%:p") -- Get the full path without escaping yet

			-- Define the run commands for different programming languages
			local commands = {
				python = function()
					-- For Python, run unsaved content directly using python -c
					if vim.bo.modified then
						-- Get buffer content and escape it for shell
						local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
						local escaped_content = table.concat(lines, "\\n"):gsub('"', '\\"')
						-- Run python with the -c flag to execute content directly
						return string.format('python3 -c "%s"', escaped_content)
					else
						local escaped_filename = vim.fn.shellescape(plain_filename)
						return string.format("python3 %s", escaped_filename)
					end
				end,

				java = function()
					-- For Java, require saving first (don't use temp files)
					if vim.bo.modified then
						vim.notify("Please save your Java file before running it.", vim.log.levels.WARN)
						return nil
					end

					-- Check if the project is a Gradle or Maven project
					if project_info.has_gradle then
						return "./gradlew run"
					elseif project_info.has_pom then
						return "mvn exec:java"
					else
						local class_name = vim.fn.fnamemodify(plain_filename, ":t:r") -- Get the Java class name
						local package_name = extract_java_package(content)
						local ui_frameworks = detect_java_ui_frameworks(content)

						-- Base command components
						local compile_cmd = ""
						local run_cmd = ""
						local modules = ""

						-- Add JavaFX module path for JavaFX applications
						if ui_frameworks.has_javafx then
							-- Path to JavaFX SDK - using JAVAFX_HOME environment variable
							modules =
								'--module-path "$JAVAFX_HOME/lib" --add-modules javafx.controls,javafx.fxml,javafx.graphics '
						end

						-- Add headless=false if using AWT, Swing or JOptionPane
						if ui_frameworks.has_swing or ui_frameworks.has_awt or ui_frameworks.has_optionpane then
							modules = modules .. "-Djava.awt.headless=false "
						end

						-- Handle files with package declarations
						if package_name then
							local file_dir = vim.fn.fnamemodify(plain_filename, ":h") -- Get directory of the file
							local package_path = package_name:gsub("%.", "/")
							local root_dir = file_dir:gsub("/" .. package_path .. "$", "")

							-- Escape the root directory for shell
							local escaped_root_dir = vim.fn.shellescape(root_dir)

							-- Create the compile and run commands with proper escaping
							compile_cmd =
								string.format("cd %s && javac %s/%s.java", escaped_root_dir, package_path, class_name)

							run_cmd = string.format("java %s%s.%s", modules, package_name, class_name)

							return compile_cmd .. " && " .. run_cmd
						else
							-- No package declaration, simpler case
							local escaped_filename = vim.fn.shellescape(plain_filename)
							compile_cmd = string.format("javac %s", escaped_filename)
							run_cmd = string.format("java %s%s", modules, class_name)

							return compile_cmd .. " && " .. run_cmd
						end
					end
				end,

				javascript = function()
					-- Require saving JavaScript files before running
					if vim.bo.modified then
						vim.notify("Please save your JavaScript file before running it.", vim.log.levels.WARN)
						return nil
					else
						local escaped_filename = vim.fn.shellescape(plain_filename)
						return string.format("node %s", escaped_filename)
					end
				end,

				lua = function()
					-- Require saving Lua files before running
					if vim.bo.modified then
						vim.notify("Please save your Lua file before running it.", vim.log.levels.WARN)
						return nil
					else
						local escaped_filename = vim.fn.shellescape(plain_filename)
						return string.format("lua %s", escaped_filename)
					end
				end,
			}

			return commands[filetype] and commands[filetype]() or nil -- Return the appropriate command based on filetype
		end

		-- Terminal configuration initialization
		require("toggleterm").setup({
			size = function(term)
				-- Dynamically set the terminal size based on the direction
				if term.direction == "horizontal" then
					return 15 -- Horizontal terminal size (in lines)
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4 -- Vertical terminal size (as a percentage of the screen width)
				end
			end,

			-- Configuration for floating terminal windows
			float_opts = {
				border = "curved", -- Curved border
				width = 160, -- Width of the floating window
				height = 40, -- Height of the floating window
				winblend = 10, -- Transparency of the floating window
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
				return -- Command will be nil if file needs to be saved first
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
