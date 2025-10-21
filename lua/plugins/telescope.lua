-- Fuzzy Finder and Search for Neovim

return {
	"nvim-telescope/telescope.nvim", -- Plugin repository
	branch = "0.1.x", -- Specify to use the stable branch for reliability and compatibility
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for async operations and utility functions
		"nvim-telescope/telescope-ui-select.nvim", -- Provides an enhanced UI for selections (dropdown theme)
	},
	config = function()
		-- Import necessary Telescope functions
		local telescope = require("telescope") -- Telescope core
		local builtin = require("telescope.builtin") -- Default built-in Telescope pickers

		-- Global Telescope configuration
		telescope.setup({
			defaults = {
				path_display = { truncate = 20 },
				-- File ignore patterns
				file_ignore_patterns = {
					"node_modules", -- Exclude node_modules folder from search results
					".git", -- Exclude .git directory (version control files)
					".cache", -- Exclude cache files for faster searching
				},
			},

			-- Extensions configuration (in this case, the ui-select extension)
			extensions = {
				["ui-select"] = {
					-- Load the dropdown theme for the UI select extension
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		-- Enable the ui-select extension which provides a nicer UI for selections
		telescope.load_extension("ui-select")

		-- Keybinding Configuration
		-- Map <leader>ff to find files in the parent directory
		vim.keymap.set("n", "<leader>ff", function()
			-- Gets the parent directory of the current file for a broader search scope
			local parent_dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":h")
			-- Use Telescope's find_files picker to search files within the parent directory
			builtin.find_files({ cwd = parent_dir })
		end, { noremap = true }) -- Non-recursive mapping, so the key won't trigger other mappings

		-- Map <leader>fg to live grep in the parent directory
		vim.keymap.set("n", "<leader>fg", function()
			-- Gets the parent directory of the current file for a broader search scope
			local parent_dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":h")
			-- Use Telescope's live_grep picker to search for text within files in the parent directory
			builtin.live_grep({ cwd = parent_dir })
		end, { noremap = true }) -- Non-recursive mapping

		-- Map <leader>fb to open buffer picker (displays a list of open buffers)
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { noremap = true })

		-- Map <leader>fh to open help tags picker (displays a list of available help files)
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { noremap = true })
	end,
}
