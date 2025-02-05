-- File Explorer and Git Status for Neovim

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x", -- Specify to use the stable v3 branch of the plugin

	dependencies = {
		"nvim-lua/plenary.nvim", -- Utility functions library, required by Neo-tree
		"nvim-tree/nvim-web-devicons", -- Provides file type icons for a better visual experience
		"MunifTanjim/nui.nvim", -- UI component library required for Neo-tree's UI elements
	},

	-- Plugin configuration function
	config = function()
		-- Initialize and configure Neo-tree
		require("neo-tree").setup({
			-- Configure the available sources or views to display in the Neo-tree panel
			sources = {
				"filesystem", -- Enable the file explorer view
				"buffers", -- Enable the open buffers view
				"git_status", -- Enable the Git status view to track changes in the repository
			},

			-- Configuration specific to the filesystem view
			filesystem = {
				-- Configure how the current file is highlighted in the file explorer
				follow_current_file = {
					enabled = true, -- Automatically highlight the current file in the explorer
					leave_dirs_open = true, -- Keep parent directories open when navigating to a file
				},

				-- Use libuv for file watching, which is efficient for detecting changes
				use_libuv_file_watcher = true, -- Enable file system watching for automatic updates

				-- Allows browsing outside the current working directory
				bind_to_cwd = false, -- Set to false to allow exploring files outside the current working directory

				-- File/folder filtering configuration to hide certain files or patterns
				filtered_items = {
					visible = false, -- Hide filtered items from the explorer
					hide_dotfiles = true, -- Hide files that begin with a dot (e.g., .git, .cache)
					hide_gitignored = true, -- Hide files listed in the .gitignore file
					hide_by_pattern = { -- Hide files that match specific patterns
						"omp.cache*", -- Hide any file starting with "omp.cache"
					},
					hide_by_name = { -- Hide files or folders by specific name
						".git", -- Hide the .git directory
						"node_modules", -- Hide node_modules directory
						".cache", -- Hide cache directories
					},
				},

				-- Configure window-specific settings and key mappings for filesystem view
				window = {
					mappings = {
						["u"] = "navigate_up", -- Map 'u' to navigate up one directory level
						["e"] = "set_root", -- Map 'e' to set the current directory as root
					},
				},
			},

			-- Global configuration for the Neo-tree window appearance and behavior
			window = {
				position = "left", -- Position the Neo-tree window on the left side of the editor
				width = 30, -- Set the width of the Neo-tree window to 30 columns
				mapping_options = {
					noremap = true, -- Disable recursive key mappings for these actions
					nowait = true, -- Disable waiting for other mappings when a key is pressed
				},
				mappings = {
					["u"] = "navigate_up", -- Global mapping for navigating up a directory
					["e"] = "set_root", -- Global mapping for setting the root directory
				},
			},
		})

		-- State variable to track whether Neo-tree is visible or not
		local neo_tree_visible = false

		-- Smart toggle function that opens/closes Neo-tree based on visibility
		vim.keymap.set("n", "<leader>n", function()
			-- Get the current file's absolute path
			local file_path = vim.fn.expand("%:p")
			-- Get the directory of the current file
			local current_dir = vim.fn.fnamemodify(file_path, ":h")

			if neo_tree_visible then
				-- If Neo-tree is visible, close it
				vim.cmd("Neotree close")
				neo_tree_visible = false
			else
				-- If Neo-tree is not visible, change the working directory to the current file's directory and open Neo-tree
				vim.cmd("cd " .. current_dir)
				vim.cmd("Neotree reveal")
				neo_tree_visible = true
			end
		end, { noremap = true, silent = true }) -- Set keymap with non-recursive and silent options
	end,
}
