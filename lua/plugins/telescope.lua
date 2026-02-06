-- Fuzzy Finder and Search for Neovim

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for async operations and utility functions
		"nvim-telescope/telescope-ui-select.nvim", -- Enhanced UI for selections
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		-- Smart root detection: git root → parent dir → cwd
		local function get_smart_root()
			-- Try to find git root first
			local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
			if vim.v.shell_error == 0 and git_root and git_root ~= "" then
				return git_root
			end

			-- No git? Use parent directory of current file
			local current_file = vim.fn.expand("%:p")
			if current_file ~= "" then
				return vim.fn.fnamemodify(current_file, ":h:h") -- parent dir
			end

			-- Fallback to current working directory
			return vim.fn.getcwd()
		end

		-- Global Telescope configuration
		telescope.setup({
			defaults = {
				-- Better path display
				path_display = { "smart" },

				-- Faster search with ripgrep
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden", -- Search hidden files
					"--glob=!.git/", -- But ignore .git directory
				},

				-- File ignore patterns
				file_ignore_patterns = {
					"node_modules",
					".git/",
					".cache",
					"%.class", -- Java compiled files
					"%.o", -- C object files
					"%.pyc", -- Python bytecode
				},

				-- Layout
				layout_config = {
					horizontal = {
						preview_width = 0.55,
					},
				},
			},

			-- Extensions configuration
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		-- Load extensions
		telescope.load_extension("ui-select")

		-- Keybinding Configuration

		-- <leader>ff - Find files (smart root: git → parent → cwd)
		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({ cwd = get_smart_root() })
		end, { noremap = true, desc = "Find files" })

		-- <leader>fg - Live grep (smart root: git → parent → cwd)
		vim.keymap.set("n", "<leader>fg", function()
			builtin.live_grep({ cwd = get_smart_root() })
		end, { noremap = true, desc = "Live grep" })

		-- <leader>fb - Open buffers
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { noremap = true, desc = "Find buffers" })

		-- <leader>fh - Help tags
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { noremap = true, desc = "Help tags" })

		-- <leader>fr - Recently opened files
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { noremap = true, desc = "Recent files" })

		-- <leader>fw - Search word under cursor (in project)
		vim.keymap.set("n", "<leader>fw", function()
			builtin.grep_string({ cwd = get_smart_root() })
		end, { noremap = true, desc = "Find word under cursor" })

		-- <leader>fc - Search in current buffer (fuzzy find current file)
		vim.keymap.set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, {
			noremap = true,
			desc = "Find in current buffer",
		})

		-- <leader>fd - Search diagnostics (LSP errors/warnings)
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { noremap = true, desc = "Find diagnostics" })

		-- <leader>fs - Search symbols in current file (functions, classes, etc.)
		vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {
			noremap = true,
			desc = "Find symbols in file",
		})

		-- <leader>fk - Keymaps (see all your keybindings)
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { noremap = true, desc = "Find keymaps" })
	end,
}
