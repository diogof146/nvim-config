-- Syntax Highlighting and Smart Indentation

return {
	"nvim-treesitter/nvim-treesitter",

	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })
	end,

	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"python",
				"java",
				"lua",
				"c",
				"cpp",
				"bash",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"json",
				"yaml",
				"toml",
				"xml",
				"markdown",
				"r",
			},

			-- Enable syntax highlighting
			highlight = { enable = true },

			-- Enable smart indentation
			indent = { enable = true },

			-- Auto-install missing parsers
			auto_install = true,
		}) -- This was missing

		-- Custom fold text function to show function signatures
		_G.custom_fold_text = function()
			local start_line = vim.fn.getline(vim.v.foldstart)
			local lines_count = vim.v.foldend - vim.v.foldstart + 1

			-- Clean up the start line
			local cleaned_line = start_line:gsub("^%s*", ""):gsub("%s*{%s*$", ""):gsub("%s*$", "")

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

			return signature .. " ... [" .. lines_count .. " lines]"
		end

		-- Folding setup
		vim.opt.foldmethod = "manual"
		vim.opt.foldtext = "v:lua.custom_fold_text()"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldnestmax = 10
		vim.opt.fillchars = { fold = " " }

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

		-- Toggle fold for current function
		local function toggle_current_function()
			local cursor = vim.api.nvim_win_get_cursor(0)
			local current_line = cursor[1]

			-- Check if we're already in a fold
			local fold_start = vim.fn.foldclosed(current_line)
			if fold_start ~= -1 then
				vim.cmd("normal! zo")
				return
			end

			-- Check if we're in an open fold
			local fold_level = vim.fn.foldlevel(current_line)
			if fold_level > 0 then
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
				vim.cmd("normal! za")
				return
			end

			-- Find function end
			local function_end = nil
			local start_indent = vim.fn.indent(function_start)

			for i = function_start + 1, vim.fn.line("$") do
				local line = vim.fn.getline(i)
				if line:match("^%s*$") then
					goto continue
				end

				local current_indent = vim.fn.indent(i)
				if current_indent <= start_indent and not line:match("^%s*}") and not line:match("^%s*%)") then
					function_end = i - 1
					break
				end
				::continue::
			end

			if not function_end then
				function_end = vim.fn.line("$")
			end

			-- Create the fold
			if function_start and function_end and function_end > function_start then
				vim.cmd(string.format("%d,%dfold", function_start, function_end))
			else
				vim.cmd("normal! za")
			end
		end

		-- Toggle all functions in the file
		local function toggle_all_functions()
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
				vim.cmd("normal! zR")
			else
				-- Find and fold all functions
				local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

				for i, line in ipairs(lines) do
					if is_function_start(line) then
						local function_start = i
						local start_indent = vim.fn.indent(i)
						local function_end = nil

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

						if function_end > function_start then
							vim.cmd(string.format("%d,%dfold", function_start, function_end))
						end
					end
				end
			end

			vim.api.nvim_win_set_cursor(0, cursor)
		end

		-- Folding keymaps
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
