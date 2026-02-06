-- Terminal Integration for Neovim

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		-- Check if file needs saving before running
		local function require_save(filetype)
			if vim.bo.modified then
				vim.notify(string.format("Please save your %s file before running it.", filetype), vim.log.levels.WARN)
				return true
			end
			return false
		end

		-- Function to find the project root by looking for pom.xml or build.gradle
		local function find_project_root(start_path)
			local current_path = start_path or vim.fn.expand("%:p:h")

			-- Safety check: ensure we have a valid path
			if not current_path or current_path == "" then
				return nil, nil
			end

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
			return string.match(content, "package%s+([%w%.]+)%s*;")
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
		local function get_run_command(filetype)
			local filepath = vim.fn.expand("%:p")
			local filename = vim.fn.expand("%:t")
			local file_dir = vim.fn.fnamemodify(filepath, ":h")

			-- Define the run commands for different programming languages
			local commands = {
				python = function()
					-- For Python, run unsaved content directly using temp file
					if vim.bo.modified then
						local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
						local temp_file = os.tmpname() .. ".py"
						local f = io.open(temp_file, "w")
						if not f then
							vim.notify("Failed to create temp file for Python", vim.log.levels.ERROR)
							return nil
						end
						f:write(table.concat(lines, "\n"))
						f:close()
						return string.format(
							"cd %s && python3 %s; rm %s",
							vim.fn.shellescape(file_dir),
							vim.fn.shellescape(temp_file),
							vim.fn.shellescape(temp_file)
						)
					else
						return string.format(
							"cd %s && python3 %s",
							vim.fn.shellescape(file_dir),
							vim.fn.shellescape(filename)
						)
					end
				end,

				java = function()
					if require_save("Java") then
						return nil
					end

					local project_info = detect_project_type()
					local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

					-- Check if the project is a Gradle or Maven project
					if project_info.has_gradle and project_info.project_root then
						return string.format("cd %s && ./gradlew run", vim.fn.shellescape(project_info.project_root))
					elseif project_info.has_pom and project_info.project_root then
						local escaped_root = vim.fn.shellescape(project_info.project_root)
						local pom_path = project_info.project_root .. "/pom.xml"

						-- Safety check for pom.xml readability
						if vim.fn.filereadable(pom_path) ~= 1 then
							vim.notify("pom.xml not readable", vim.log.levels.ERROR)
							return nil
						end

						local pom_content = vim.fn.readfile(pom_path)
						local pom_text = table.concat(pom_content, "\n")

						-- Check if this is a JavaFX Maven project
						local has_javafx_plugin = string.match(pom_text, "<groupId>org%.openjfx</groupId>") ~= nil
							or string.match(pom_text, "javafx%-maven%-plugin") ~= nil

						if has_javafx_plugin then
							return string.format(
								'cd %s && mvn clean javafx:run -Djavafx.args="-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false"',
								escaped_root
							)
						else
							-- Regular Maven project
							local main_class_in_pom = string.match(pom_text, "<mainClass>([^<]+)</mainClass>")

							if main_class_in_pom then
								return string.format(
									'cd %s && mvn -q exec:java -Dexec.args="-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false"',
									escaped_root
								)
							else
								-- Try to find the main class from the current file
								local package_name = extract_java_package(content)
								local class_name = vim.fn.fnamemodify(filepath, ":t:r")

								if package_name then
									return string.format(
										'cd %s && mvn -q exec:java -Dexec.mainClass="%s.%s" -Dexec.args="-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false"',
										escaped_root,
										package_name,
										class_name
									)
								else
									return string.format(
										'cd %s && mvn -q exec:java -Dexec.mainClass="%s" -Dexec.args="-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false"',
										escaped_root,
										class_name
									)
								end
							end
						end
					else
						-- Standalone Java file (no Maven/Gradle)
						local class_name = vim.fn.fnamemodify(filepath, ":t:r")
						local package_name = extract_java_package(content)
						local ui_frameworks = detect_java_ui_frameworks(content)

						local modules = ""

						-- Add JavaFX module path for JavaFX applications
						if ui_frameworks.has_javafx then
							modules =
								'--module-path "$JAVAFX_HOME/lib" --add-modules javafx.controls,javafx.fxml,javafx.graphics '
						end

						-- Add headless=false if using AWT, Swing or JOptionPane
						if ui_frameworks.has_swing or ui_frameworks.has_awt or ui_frameworks.has_optionpane then
							modules = modules .. "-Djava.awt.headless=false "
						end

						-- Add macOS JavaFX accessibility fix
						if ui_frameworks.has_javafx then
							modules = modules .. "-Dcom.apple.awt.UIElement=true -Djavafx.accessibility.force=false "
						end

						-- Handle files with package declarations
						if package_name then
							local package_path = package_name:gsub("%.", "/")
							local root_dir = file_dir:gsub("/" .. package_path .. "$", "")
							local escaped_root_dir = vim.fn.shellescape(root_dir)

							local compile_cmd =
								string.format("cd %s && javac %s/%s.java", escaped_root_dir, package_path, class_name)
							local run_cmd = string.format(
								"cd %s && java %s%s.%s",
								escaped_root_dir,
								modules,
								package_name,
								class_name
							)

							return compile_cmd .. " && " .. run_cmd
						else
							-- No package declaration
							local compile_cmd = string.format(
								"cd %s && javac %s",
								vim.fn.shellescape(file_dir),
								vim.fn.shellescape(filename)
							)
							local run_cmd =
								string.format("cd %s && java %s%s", vim.fn.shellescape(file_dir), modules, class_name)

							return compile_cmd .. " && " .. run_cmd
						end
					end
				end,

				javascript = function()
					if require_save("JavaScript") then
						return nil
					end
					return string.format("cd %s && node %s", vim.fn.shellescape(file_dir), vim.fn.shellescape(filename))
				end,

				lua = function()
					if require_save("Lua") then
						return nil
					end
					return string.format("cd %s && lua %s", vim.fn.shellescape(file_dir), vim.fn.shellescape(filename))
				end,

				r = function()
					if require_save("R") then
						return nil
					end
					return string.format(
						"cd %s && Rscript %s",
						vim.fn.shellescape(file_dir),
						vim.fn.shellescape(filename)
					)
				end,

				c = function()
					if require_save("C") then
						return nil
					end
					local output = vim.fn.fnamemodify(filepath, ":t:r")
					return string.format(
						"cd %s && gcc %s -o %s && ./%s",
						vim.fn.shellescape(file_dir),
						vim.fn.shellescape(filename),
						vim.fn.shellescape(output),
						vim.fn.shellescape(output)
					)
				end,

				bash = function()
					if require_save("Bash") then
						return nil
					end
					return string.format("cd %s && bash %s", vim.fn.shellescape(file_dir), vim.fn.shellescape(filename))
				end,

				sh = function()
					if require_save("Shell") then
						return nil
					end
					return string.format("cd %s && sh %s", vim.fn.shellescape(file_dir), vim.fn.shellescape(filename))
				end,

				-- Viewers/Formatters
				markdown = function()
					if vim.fn.executable("glow") == 1 then
						return string.format("glow %s", vim.fn.shellescape(filepath))
					else
						vim.notify("glow not found. Install with: brew install glow", vim.log.levels.WARN)
						return nil
					end
				end,

				html = function()
					-- Open in default browser
					if vim.fn.has("mac") == 1 then
						return string.format("open %s", vim.fn.shellescape(filepath))
					elseif vim.fn.has("unix") == 1 then
						return string.format("xdg-open %s", vim.fn.shellescape(filepath))
					elseif vim.fn.has("win32") == 1 then
						return string.format("start %s", vim.fn.shellescape(filepath))
					end
				end,

				css = function()
					vim.notify("CSS files can't be run directly. Open the associated HTML file.", vim.log.levels.INFO)
					return nil
				end,

				json = function()
					-- Pretty print JSON using jq if available
					if vim.fn.executable("jq") == 1 then
						return string.format("jq . %s", vim.fn.shellescape(filepath))
					else
						return string.format("cat %s", vim.fn.shellescape(filepath))
					end
				end,

				yaml = function()
					-- Validate and display YAML
					if vim.fn.executable("yq") == 1 then
						return string.format("yq eval %s", vim.fn.shellescape(filepath))
					else
						return string.format("cat %s", vim.fn.shellescape(filepath))
					end
				end,

				toml = function()
					-- Just display TOML
					return string.format("cat %s", vim.fn.shellescape(filepath))
				end,
			}

			return commands[filetype] and commands[filetype]() or nil
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
			local filetype = vim.bo.filetype
			local command = get_run_command(filetype)

			if not command then
				return -- Command will be nil if file needs to be saved first or is unsupported
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
				end,

				on_exit = function(_, _, exit_code, _)
					if exit_code ~= 0 then
						vim.notify(string.format("Process exited with code %d", exit_code), vim.log.levels.WARN)
					end
				end,
			})

			runner:toggle() -- Toggle the terminal window
		end

		-- Global keybindings for running files and toggling the terminal
		vim.keymap.set("n", "<F6>", run_file, { noremap = true, silent = true })
		vim.keymap.set({ "n", "t" }, "<F5>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
	end,
}
