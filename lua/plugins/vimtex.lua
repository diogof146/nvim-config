-- VimTeX provides features like compilation, viewer integration, syntax highlighting,
-- text objects, motions, and more for LaTeX documents

return {
	"lervag/vimtex",

	lazy = false,

	-- ft = {"tex", "latex"} can be used instead of lazy=false

	config = function()
		-- Set PDF viewer to Skim
		-- Skim provides SyncTeX support for bidirectional navigation between source and PDF
		vim.g.vimtex_view_method = "skim"

		-- Enable Skim activation when viewing
		-- This ensures Skim is brought to the foreground when viewing the PDF
		vim.g.vimtex_view_skim_activate = 1

		-- Enable SyncTeX with Skim
		-- This enables proper synchronization between source and PDF
		vim.g.vimtex_view_skim_sync = 1

		-- Configure latexmk as the compiler method
		-- latexmk automates the process of compiling LaTeX documents with the correct number of runs
		vim.g.vimtex_compiler_method = "latexmk"

		-- Configure latexmk options if needed
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "", -- Build directory (empty = same as source)
			callback = 1, -- Enable callback functions for continuous compilation
			continuous = 1, -- Enable continuous mode (auto-compile on changes)
			executable = "/Library/TeX/texbin/latexmk", -- Full path to latexmk executable
			options = {
				"-pdf", -- Generate PDF output
				"-verbose", -- Be verbose
				"-file-line-error", -- Enable file:line:error style messages
				"-synctex=1", -- Enable SyncTeX for viewer integration
				"-interaction=nonstopmode", -- Don't stop on errors
				"-shell-escape", -- Allow shell commands (helps with paths that have spaces)
			},
		}

		-- Completely disable automatic quickfix window opening
		vim.g.vimtex_quickfix_mode = 0

		-- Don't open quickfix window automatically for warnings
		vim.g.vimtex_quickfix_open_on_warning = 0

		-- Handle spaces in filenames by using quotes when needed
		vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]

		-- Handle shell escaping with spaces in commands
		vim.g.vimtex_shell_escape_mode = "quote"

		-- Disable search in included files which can have issues with spaces in paths
		vim.g.vimtex_include_search_enabled = 0

		-- Configure Skim as viewer with proper escaped options to handle spaces in paths
		vim.g.vimtex_view_skim_options = [[--unique "file://@pdf" --page @line]]

		-- Set mappings prefix for VimTeX commands (default is '\l')
		vim.g.vimtex_mappings_prefix = "\\l"

		-- Enable imaps (insert mode mappings) for faster typing of common LaTeX commands
		-- These allow you to type 'mk' and get '$$ $$' with cursor positioned in the middle
		vim.g.vimtex_imaps_enabled = 1

		-- Enable deleting surrounding environments with 'dse', changing with 'cse'
		vim.g.vimtex_text_obj_enabled = 1

		-- Enable subfile support
		vim.g.vimtex_subfile_start_local = 1

		-- Configure ToC (Table of Contents) window
		vim.g.vimtex_toc_config = {
			split_width = 30, -- Width of TOC window
			layer_status = { -- TOC layer status
				content = 1, -- 1 = show content layer
				label = 1, -- 1 = show label layer
				todo = 1, -- 1 = show todo layer
			},
		}

		-- Configure custom key mappings
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "tex",
			callback = function()
				-- Local mapping to compile document
				vim.api.nvim_buf_set_keymap(
					0,
					"n",
					"<leader>lc",
					"<cmd>VimtexCompile<CR>",
					{ noremap = true, silent = true }
				)
				-- Local mapping to view document
				vim.api.nvim_buf_set_keymap(
					0,
					"n",
					"<leader>lv",
					"<cmd>VimtexView<CR>",
					{ noremap = true, silent = true }
				)
				-- Local mapping to show errors
				vim.api.nvim_buf_set_keymap(
					0,
					"n",
					"<leader>le",
					"<cmd>VimtexErrors<CR>",
					{ noremap = true, silent = true }
				)
			end,
		})

		-- Create a backup manual PDF opener function in case automatic methods fail
		vim.api.nvim_create_user_command("OpenPDF", function()
			local pdf_file = string.gsub(vim.fn.expand("%:p"), "%.tex$", ".pdf")
			vim.fn.system('open -a Skim "' .. pdf_file .. '"')
			print("Opening PDF: " .. pdf_file)
		end, {})

		-- Map the backup PDF opener to a key combination
		vim.api.nvim_set_keymap("n", "<leader>lo", ":OpenPDF<CR>", { noremap = true, silent = true })

		-- Explanation of common VimTeX commands:
		-- \ll - Compile document (toggles continuous compilation)
		-- \lv - Forward search (view PDF at current position)
		-- \lt - Open table of contents
		-- \lT - Toggle table of contents
		-- \lc - Clear auxiliary files
		-- \lC - Clean all output files
		-- \le - Show compilation errors
		-- \lk - Stop compilation
		-- \lK - Kill compilation process
		-- dse - Delete surrounding environment
		-- cse - Change surrounding environment
		-- tse - Toggle surrounding environment star (e.g., equation <-> equation*)
		-- <leader>lo - Manual backup PDF opener (added for paths with spaces)
	end,
}
