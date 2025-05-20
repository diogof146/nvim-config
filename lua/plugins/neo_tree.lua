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
				-- KEY CHANGE: Disable cwd binding to prevent prompts
				bind_to_cwd = false, -- Never prompt about directory changes
				cwd_target = {
					sidebar = "none", -- Don't change cwd when opening sidebar
					current = "none", -- Don't prompt when following current file
				},
				-- KEY CHANGE: Disable netrw hijacking to avoid prompts
				hijack_netrw_behavior = "disabled", -- Disable netrw hijacking completely
				-- These settings prevent directory change prompts
				find_by_full_path_words = true,
				group_empty_dirs = false,
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
					never_show = { -- Never show these files/folders
						".DS_Store",
						"thumbs.db",
					},
				},
				-- Configure window-specific settings and key mappings for filesystem view
				window = {
					mappings = {
						["b"] = "navigate_up", -- Map 'b' to navigate up one directory level
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
					["b"] = "navigate_up", -- Global mapping for navigating up a directory
					["e"] = "set_root", -- Global mapping for setting the root directory
				},
			},
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						-- Disable line numbers in Neo-tree window for cleaner look
						vim.opt_local.number = false
						vim.opt_local.relativenumber = false
					end,
				},
			},
		})

		-- Improved toggle function that's faster and doesn't prompt for directory changes
		vim.keymap.set("n", "<leader>n", function()
			-- Get the window IDs of any Neo-tree windows
			local neo_tree_windows = {}
			for _, win in pairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local buf_name = vim.api.nvim_buf_get_name(buf)
				if buf_name:match("neo%-tree") then
					table.insert(neo_tree_windows, win)
				end
			end

			-- If Neo-tree is open, close it
			if #neo_tree_windows > 0 then
				vim.cmd("Neotree close")
			else
				-- If Neo-tree is not open, open it and focus the current file without prompts
				vim.cmd("Neotree reveal_force_cwd")
			end
		end, { noremap = true, silent = true })
	end,
}
