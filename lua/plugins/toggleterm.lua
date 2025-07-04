-- Terminal Integration for Neovim

return {
	"akinsho/toggleterm.nvim",
	version = "*", -- Use the latest available version
	config = function()
		-- Core state management
		local terminal_state = {
			last_position = nil, -- Tracks the cursor position in the terminal for restore after exiting
		}

		-- Function to find the project root by looking for pom.xml or build.gradle
		local function find_project_root(start_path)
			local current_path = start_path or vim.fn.expand("%:p:h")

			while current_path ~= "/" and current_path ~= "" do
				-- Check for pom.xml (Maven)
				if vim.fn.filereadable(current_path .. "/pom.xml") == 1 then
					return current_path, "maven"
				end
				-- Check for build.gradle (Gradle)
				if vim.fn.filereadable(current_path .. "/build.gradle") == 1 then
					return current_path, "gradle"
				end
				-- Move up one directory
				current_path = vim.fn.fnamemodify(current_path, ":h")
			end

			return nil, nil
		end

		-- Function to detect project type by checking for specific configuration files
		local function detect_project_type()
			local project_root, project_type = find_project_root()
			return {
				has_pom = project_type == "maven",
				has_gradle = project_type == "gradle",
				project_root = project_root,
				project_type = project_type,
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
		-- Modified to always run from the file's directory for non-Maven/Gradle projects
		local function get_run_command(filename, filetype)
			local project_info = detect_project_type() -- Detect if the project uses Maven or Gradle
			local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") -- Get the current buffer's content
			local plain_filename = vim.fn.expand("%:p") -- Get the full path without escaping yet
			local file_dir = vim.fn.fnamemodify(plain_filename, ":h") -- Get the directory containing the file

			-- Define the run commands for different programming languages
			-- Each command now includes a cd to the appropriate directory first
			local commands = {
				python = function()
					-- For Python, run unsaved content directly using python -c
					if vim.bo.modified then
						-- Get buffer content and escape it for shell
						local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
						local escaped_content = table.concat(lines, "\\n"):gsub('"', '\\"')
						-- Run python with the -c flag to execute content directly
						return string.format('cd %s && python3 -c "%s"', vim.fn.shellescape(file_dir), escaped_content)
					else
						local escaped_filename = vim.fn.shellescape(vim.fn.fnamemodify(plain_filename, ":t")) -- Just filename
						return string.format("cd %s && python3 %s", vim.fn.shellescape(file_dir), escaped_filename)
					end
				end,

				java = function()
					-- For Java, require saving first (don't use temp files)
					if vim.bo.modified then
						vim.notify("Please save your Java file before running it.", vim.log.levels.WARN)
						return nil
					end

					-- Check if the project is a Gradle or Maven project
					if project_info.has_gradle and project_info.project_root then
						local escaped_root = vim.fn.shellescape(project_info.project_root)
						return string.format("cd %s && ./gradlew run", escaped_root)
					elseif project_info.has_pom and project_info.project_root then
						local escaped_root = vim.fn.shellescape(project_info.project_root)

						-- Read pom.xml content for analysis
						local pom_content = vim.fn.readfile(project_info.project_root .. "/pom.xml")
						local pom_text = table.concat(pom_content, "\n")

						-- Check if this is a JavaFX Maven project by looking for javafx-maven-plugin
						local has_javafx_plugin = string.match(pom_text, "<groupId>org%.openjfx</groupId>") ~= nil
							or string.match(pom_text, "javafx%-maven%-plugin") ~= nil

						if has_javafx_plugin then
							-- This is a JavaFX Maven project - use mvn javafx:run with macOS fix
							return string.format(
								'cd %s && mvn clean javafx:run -Djavafx.args="-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false"',
								escaped_root
							)
						else
							-- Regular Maven project - use exec:java
							-- Look for mainClass in pom.xml configuration
							local main_class_in_pom = string.match(pom_text, "<mainClass>([^<]+)</mainClass>")

							if main_class_in_pom then
								-- Use the mainClass from pom.xml with macOS JavaFX fix
								return string.format(
									'cd %s && mvn -q exec:java -Dexec.args="-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false"',
									escaped_root
								)
							else
								-- Try to find the main class from the current file
								local package_name = extract_java_package(content)
								local class_name = vim.fn.fnamemodify(plain_filename, ":t:r")

								if package_name then
									local full_class_name = package_name .. "." .. class_name
									return string.format(
										'cd %s && mvn -q exec:java -Dexec.mainClass="%s" -Dexec.args="-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false"',
										escaped_root,
										full_class_name
									)
								else
									-- No package, just use class name
									return string.format(
										'cd %s && mvn -q exec:java -Dexec.mainClass="%s" -Dexec.args="-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false"',
										escaped_root,
										class_name
									)
								end
							end
						end
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

						-- Add macOS JavaFX accessibility fix for JavaFX applications
						if ui_frameworks.has_javafx then
							modules = modules .. "-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false "
						end

						-- Handle files with package declarations
						if package_name then
							local package_path = package_name:gsub("%.", "/")
							local root_dir = file_dir:gsub("/" .. package_path .. "$", "")

							-- Escape the root directory for shell
							local escaped_root_dir = vim.fn.shellescape(root_dir)

							-- Create the compile and run commands with proper escaping
							compile_cmd =
								string.format("cd %s && javac %s/%s.java", escaped_root_dir, package_path, class_name)
							run_cmd = string.format(
								"cd %s && java %s%s.%s",
								escaped_root_dir,
								modules,
								package_name,
								class_name
							)

							return compile_cmd .. " && " .. run_cmd
						else
							-- No package declaration, simpler case
							local escaped_filename = vim.fn.shellescape(vim.fn.fnamemodify(plain_filename, ":t")) -- Just filename
							compile_cmd =
								string.format("cd %s && javac %s", vim.fn.shellescape(file_dir), escaped_filename)
							run_cmd =
								string.format("cd %s && java %s%s", vim.fn.shellescape(file_dir), modules, class_name)

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
						local escaped_filename = vim.fn.shellescape(vim.fn.fnamemodify(plain_filename, ":t")) -- Just filename
						return string.format("cd %s && node %s", vim.fn.shellescape(file_dir), escaped_filename)
					end
				end,

				lua = function()
					-- Require saving Lua files before running
					if vim.bo.modified then
						vim.notify("Please save your Lua file before running it.", vim.log.levels.WARN)
						return nil
					else
						local escaped_filename = vim.fn.shellescape(vim.fn.fnamemodify(plain_filename, ":t")) -- Just filename
						return string.format("cd %s && lua %s", vim.fn.shellescape(file_dir), escaped_filename)
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
