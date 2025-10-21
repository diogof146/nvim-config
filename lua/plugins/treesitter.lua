-- Syntax Highlighting and Smart Indentation for Neovim
return {
	"nvim-treesitter/nvim-treesitter",
	-- The `build` function runs when the plugin is installed.
	-- It updates the Treesitter parsers to ensure you have the latest versions.
	build = function()
		-- This ensures that any new or updated parsers are fetched and installed immediately.
		-- The `with_sync = true` ensures this update is done synchronously, meaning the process
		-- will complete before Neovim continues loading.
		require("nvim-treesitter.install").update({ with_sync = true })
	end,
	-- The `config` function is called once the plugin has been loaded, to apply custom configuration.
	config = function()
		-- Load Treesitter configurations
		require("nvim-treesitter.configs").setup({
			-- List of programming languages for which parsers should be installed.
			ensure_installed = {
				"javascript",
				"typescript",
				"html",
				"css",
				"python",
				"java",
				"lua",
				"r",
			},
			-- Enable syntax highlighting via Treesitter.
			highlight = { enable = true },
			-- Enable smart indentation using Treesitter.
			indent = { enable = true },
			-- Automatically install any missing parsers for the configured languages.
			auto_install = true,
		})

		-- Custom fold text function to show function signatures
		_G.custom_fold_text = function()
			local start_line = vim.fn.getline(vim.v.foldstart)
			local end_line = vim.fn.getline(vim.v.foldend)
			local lines_count = vim.v.foldend - vim.v.foldstart + 1

			-- Clean up the start line (remove extra whitespace and comments)
			local cleaned_line = start_line:gsub("^%s*", ""):gsub("%s*{%s*$", ""):gsub("%s*$", "")

			-- For different languages, try to extract function signature
			local signature = cleaned_line

			-- Handle JavaScript/TypeScript functions
			if
				cleaned_line:match("^function")
				or cleaned_line:match("^const.*=.*=>")
				or cleaned_line:match("^.*function")
			then
				signature = cleaned_line:gsub("{.*", "")
			-- Handle Python functions
			elseif cleaned_line:match("^def ") then
				signature = cleaned_line:gsub(":.*", "")
			-- Handle Java/C++ methods
			elseif cleaned_line:match("^%s*[%w_]*%s+[%w_]+%s*%(") then
				signature = cleaned_line:gsub("{.*", ""):gsub("%s*$", "")
			end

			-- Return the formatted fold text
			return signature .. " ... [" .. lines_count .. " lines]"
		end

		-- Folding setup with manual fold method for better control
		vim.opt.foldmethod = "manual"
		vim.opt.foldtext = "v:lua.custom_fold_text()"
		vim.opt.foldlevel = 99 -- Keep everything unfolded by default
		vim.opt.foldlevelstart = 99 -- Start with all folds open
		vim.opt.foldnestmax = 10 -- Maximum fold nesting
		vim.opt.fillchars = { fold = " " } -- Remove the default fold fill characters

		-- Helper function to check if line is a function start
		local function is_function_start(line)
			return line:match("^%s*function")
				or line:match("^%s*def ")
				or line:match("^%s*public.*%(")
				or line:match("^%s*private.*%(")
				or line:match("^%s*protected.*%(")
				or line:match("^%s*static.*%(")
				or line:match("^%s*const.*=.*=>")
		end

		-- Helper function to toggle fold for current function
		local function toggle_current_function()
			-- Get current cursor position
			local cursor = vim.api.nvim_win_get_cursor(0)
			local current_line = cursor[1]

			-- First check if we're already in a fold
			local fold_start = vim.fn.foldclosed(current_line)
			if fold_start ~= -1 then
				-- We're in a closed fold, open it
				vim.cmd("normal! zo")
				return
			end

			-- Check if we're in an open fold
			local fold_level = vim.fn.foldlevel(current_line)
			if fold_level > 0 then
				-- We're in an open fold, close it
				vim.cmd("normal! zc")
				return
			end

			-- Look for function start by searching backwards
			local function_start = nil
			for i = current_line, 1, -1 do
				local line = vim.fn.getline(i)
				if is_function_start(line) then
					function_start = i
					break
				end
			end

			if not function_start then
				-- If no function found, just toggle current fold if any
				vim.cmd("normal! za")
				return
			end

			-- Find function end by looking for matching braces or dedent
			local function_end = nil
			local start_indent = vim.fn.indent(function_start)

			for i = function_start + 1, vim.fn.line("$") do
				local line = vim.fn.getline(i)
				if line:match("^%s*$") then
					goto continue -- Skip empty lines
				end

				local current_indent = vim.fn.indent(i)
				-- If we find a line with same or less indentation that is not empty, that is likely the end
				if current_indent <= start_indent and not line:match("^%s*}") and not line:match("^%s*%)") then
					function_end = i - 1
					break
				end
				::continue::
			end

			if not function_end then
				function_end = vim.fn.line("$")
			end

			-- Create the fold if it doesn't exist
			if function_start and function_end and function_end > function_start then
				vim.cmd(string.format("%d,%dfold", function_start, function_end))
			else
				vim.cmd("normal! za")
			end
		end

		-- Helper function to toggle all functions in the file
		local function toggle_all_functions()
			-- Save cursor position
			local cursor = vim.api.nvim_win_get_cursor(0)

			-- Check if any folds exist
			local folds_exist = false
			for i = 1, vim.fn.line("$") do
				if vim.fn.foldclosed(i) ~= -1 then
					folds_exist = true
					break
				end
			end

			if folds_exist then
				-- Open all folds
				vim.cmd("normal! zR")
			else
				-- Find and fold all functions manually
				local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

				for i, line in ipairs(lines) do
					-- Check if line starts a function
					if is_function_start(line) then
						local function_start = i
						local start_indent = vim.fn.indent(i)
						local function_end = nil

						-- Find function end
						for j = i + 1, #lines do
							local check_line = lines[j]
							if check_line:match("^%s*$") then
								goto continue_inner
							end

							local current_indent = vim.fn.indent(j)
							if
								current_indent <= start_indent
								and not check_line:match("^%s*}")
								and not check_line:match("^%s*%)")
							then
								function_end = j - 1
								break
							end
							::continue_inner::
						end

						if not function_end then
							function_end = #lines
						end

						-- Create fold if valid range
						if function_end > function_start then
							vim.cmd(string.format("%d,%dfold", function_start, function_end))
						end
					end
				end
			end

			-- Restore cursor position
			vim.api.nvim_win_set_cursor(0, cursor)
		end

		-- Better folding keymaps with distinct functions
		vim.keymap.set(
			"n",
			"<leader>h",
			toggle_current_function,
			{ desc = "Toggle current function fold", noremap = true, silent = true }
		)
		vim.keymap.set(
			"n",
			"<leader>H",
			toggle_all_functions,
			{ desc = "Toggle all function folds", noremap = true, silent = true }
		)
	end,
}
