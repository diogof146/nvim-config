-- Neovim Startup Dashboard Configuration

return {
	"nvimdev/dashboard-nvim", -- The plugin repository (GitHub: nvimdev/dashboard-nvim)

	event = "VimEnter", -- Load the plugin when Neovim starts

	-- Plugin dependencies
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" }, -- Provides icons for files and UI elements
	},

	config = function()
		local db = require("dashboard") -- Import the dashboard module

		-- Save the original cursor settings to restore them later
		local original_guicursor = vim.opt.guicursor:get()

		-- Create an autocommand to handle settings specific to the dashboard filetype
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dashboard", -- Apply settings only for the 'dashboard' filetype
			callback = function()
				-- UI Elements: Disable cursorline, cursorcolumn, and line numbers
				vim.opt_local.cursorline = false
				vim.opt_local.cursorcolumn = false
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false

				-- Status and Sign Column: Hide the status line and sign column for a clean look
				vim.opt_local.statusline = "" -- Clear status line content
				vim.opt_local.laststatus = 0 -- Completely hide the status line
				vim.opt_local.signcolumn = "no" -- Hide the sign column (e.g., for diagnostics)

				-- Buffer and Cursor Behavior: Remove unnecessary elements and make the cursor invisible
				vim.opt_local.ruler = false -- Hide cursor position info
				vim.opt_local.list = false -- Disable listchars (e.g., trailing whitespace markers)
				vim.opt_local.bufhidden = "wipe" -- Automatically remove buffer when hidden
				vim.opt_local.guicursor = "a:block-Cursor/lCursor-blinkon0" -- Hide cursor in dashboard
				vim.cmd([[highlight Cursor blend=100]]) -- Make the cursor transparent
			end,
		})

		-- Restore the original cursor settings when leaving the dashboard
		vim.api.nvim_create_autocmd("BufLeave", {
			pattern = "*", -- Apply to all buffers
			callback = function()
				-- Only restore cursor settings if the dashboard was active
				if vim.bo.filetype == "dashboard" then
					vim.opt.guicursor = original_guicursor -- Restore original cursor appearance
					vim.cmd([[highlight Cursor blend=0]]) -- Make cursor fully visible
				end
			end,
		})

		-- Dashboard.nvim Setup
		db.setup({
			theme = "hyper", -- Use the "hyper" theme for a clean, modern appearance
			shortcut_type = "number", -- Display shortcuts as numbers for easier recognition
			shuffle_letter = false, -- Maintain consistent shortcut order
			disable_move = true, -- Prevent cursor movement in the dashboard interface

			-- Main Dashboard Configuration
			config = {
				week_header = {
					enable = true, -- Show the current week number and progress
				},

				-- Quick Action Shortcuts
				-- Define shortcuts for common actions such as file search or creating new files
				shortcut = {
					{
						desc = " Find File", -- Search for a file in the current project
						group = "Label", -- Group name for styling
						action = "Telescope find_files", -- Uses Telescope to search for files
						key = "1", -- Shortcut key for this action
					},
					{
						desc = " Recent Files", -- Access recently opened files
						group = "Label",
						action = "Telescope oldfiles", -- Uses Telescope to show recent files
						key = "2",
					},
					{
						desc = " Find Word", -- Search for a word in all files
						group = "Label",
						action = "Telescope live_grep", -- Uses Telescope to perform a text search
						key = "3",
					},
					{
						desc = " New File", -- Create a new, empty buffer
						group = "Label",
						action = "enew", -- Opens a new file
						key = "4",
					},
				},

				-- Project Section
				project = {
					enable = false, -- Disable the project section to simplify the dashboard
				},

				-- Footer Configuration
				footer = {
					"", -- Empty line for spacing
					"⚽️ SIUUUUUUUUUUUUUUUUUUUUUUUUUUUUU ⚽️", -- Muchas gracias afición, esto es para vosotros
				},
			},
		})
	end,
}
