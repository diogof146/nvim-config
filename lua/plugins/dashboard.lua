-- Neovim Startup Dashboard Configuration
-- This file configures the dashboard-nvim plugin to create a custom startup screen for Neovim
return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
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
				-- UI Elements
				vim.opt_local.cursorline = false
				vim.opt_local.cursorcolumn = false
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.laststatus = 0 -- Completely hide the status line
				vim.opt_local.signcolumn = "no" -- Hide the sign column (e.g., for diagnostics)
				vim.opt_local.ruler = true -- Hide cursor position info
				vim.opt_local.list = false -- Disable listchars (e.g., trailing whitespace markers)
				vim.opt_local.bufhidden = "wipe" -- Automatically remove buffer when hidden
				vim.opt_local.guicursor = "a:block-Cursor/lCursor-blinkon0" -- Hide cursor in dashboard
				vim.cmd([[highlight Cursor blend=100]]) -- Make the cursor transparent
				-- Background: Set black background for dashboard
				vim.cmd([[highlight DashboardNormal guibg=#000000 ctermbg=0]])
				vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
			end,
		})

		-- Fix cursor and background visibility issue when staying in the dashboard
		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
			pattern = "*",
			callback = function()
				if vim.bo.filetype == "dashboard" then
					vim.opt_local.guicursor = "a:block-Cursor/lCursor-blinkon0"
					vim.cmd([[highlight Cursor blend=100]])
					-- Ensure black background is maintained for dashboard
					vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
				else
					vim.opt.guicursor = original_guicursor
					vim.cmd([[highlight Cursor blend=0]])
					-- Restore normal background color for non-dashboard buffers
					vim.api.nvim_set_hl(0, "Normal", { bg = nil })
				end
			end,
		})

		-- Only restore the background when actually loading a real file, not just when leaving dashboard temporarily
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*",
			callback = function()
				local current_buf = vim.api.nvim_get_current_buf()
				local filename = vim.api.nvim_buf_get_name(current_buf)
				local filetype = vim.bo[current_buf].filetype

				-- Only restore settings when entering a real file (not empty or dashboard)
				if filetype ~= "dashboard" and filename ~= "" then
					vim.opt.guicursor = original_guicursor
					vim.cmd([[highlight Cursor blend=0]])
					vim.api.nvim_set_hl(0, "Normal", { bg = nil })
				end

				-- Make sure dashboard always has the black background
				if filetype == "dashboard" then
					vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
				end
			end,
		})

		db.setup({
			theme = "doom", -- Use the "doom" theme (other option would be hyper)
			shortcut_type = "letter", -- Display shortcuts as letters instead of numbers
			shuffle_letter = false, -- Maintain consistent shortcut order (no randomization)
			disable_move = true, -- Prevent cursor movement in the dashboard interface

			-- Main Dashboard Configuration
			config = {
				header = {
          "",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣷⣤⠀⠀⠀⠀⠀⠀⠀⡀⠀⣀⣀⣴⣶⠞⠁⣀⣤⠤⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⠿⣿⣿⡯⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣧⣤⣾⣿⣁⣀⠀⠀⠀⢀⣀⣤⣤⣄⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡏⠁⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⣰⣾⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⠟⠛⠿⣿⣿⣿⣿⣿⣶⣶⣦⡀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣶⣿⣿⣶⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡉⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⠁",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⣠⣤⣤⣴⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠛⠛⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⡿⠿⠿⠿⠿⠿⠋⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⠿⠿⣿⣿⣷⣶⣶⣶⣾⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣨⣿⠟⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠃⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⢸⣿⣿⣿⣿⡿⠇⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣤⣤⣶⣿⣷⣄⠀⠀⠀⠀⠸⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠉⢹⣿⣿⠉⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⢿⣿⠇⠀⠀⠀⠀⠀⢸⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⡿⠛⠛⢛⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣤⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣸⣿⡁⠀⠀⠀⠀⠀⣸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⠟⠀⠀⠀⠀⠛⠛⠛⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⣠⣤⣴⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⢸⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠀⢿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠋⠉⠻⢿⣷⣦⣼⣿⣿⣟⣉⣠⣤⣤⣄⠀⠀⠀⠀⠀",
					"⠀⣠⣄⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⠀⢹⣿⣿⣿⣆⠀⢀⣴⣤⣤⡿⠉⠉⠉⠉⠉⠁⠀⠀⠀⠉⢷⠀⠀⠀⠀",
					"⣼⣿⣿⣦⣤⣀⠀⢸⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⣿⣿⣿⣿⣿⠿⠿⢿⣿⠁⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀",
					"⠈⠿⣿⣿⣿⣿⣷⣾⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠘⠛⠛⠋⠁⠀⢰⣿⣷⣶⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠉⢿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⢠⣾⢿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠹⣿⣿⠿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⢰⣿⠏⠀⠈⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣏⠀⠀⠀⢀⣴⡿⠋⠀⠀⠀⠸⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠙⢿⣿⣿⣿⣿⣷⣶⣶⣿⠟⠁⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠻⠿⠿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"",
					"",
          "",
				},

				-- Disable week header
				week_header = {
					enable = false,
				},

				-- Quick Action Shortcuts
				shortcut = {
					{
						desc = " Find File", -- Search for a file in the current project
						group = "DashboardShortcut", -- Group name for styling
						action = "Telescope find_files", -- Uses Telescope to search for files
						key = "f", -- Shortcut key for this action
					},
					{
						desc = " Recent Files", -- Access recently opened files
						group = "DashboardShortcut",
						action = "Telescope oldfiles", -- Uses Telescope to show recent files
						key = "r",
					},
					{
						desc = " Find Word", -- Search for a word in all files
						group = "DashboardShortcut",
						action = "Telescope live_grep", -- Uses Telescope to perform a text search
						key = "g",
					},
					{
						desc = " New File", -- Create a new, empty buffer
						group = "DashboardShortcut",
						action = "enew", -- Opens a new file
						key = "n",
					},
					{
						desc = " Configuration", -- Open configuration file
						group = "DashboardShortcut",
						action = "e $MYVIMRC", -- Edit Neovim configuration
						key = "c",
					},
					{
						desc = " Quit Neovim", -- Exit the editor
						group = "DashboardShortcut",
						action = "qa", -- Quit all
						key = "q",
					},
				},

				-- Center content configuration
				center = {
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Find File",
						desc_hl = "DashboardDesc",
						key = "f",
						key_hl = "DashboardKey",
						action = "Telescope find_files",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Recent Files",
						desc_hl = "DashboardDesc",
						key = "r",
						key_hl = "DashboardKey",
						action = "Telescope oldfiles",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Find Word",
						desc_hl = "DashboardDesc",
						key = "g",
						key_hl = "DashboardKey",
						action = "Telescope live_grep",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "New File",
						desc_hl = "DashboardDesc",
						key = "n",
						key_hl = "DashboardKey",
						action = "enew",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Configuration",
						desc_hl = "DashboardDesc",
						key = "c",
						key_hl = "DashboardKey",
						action = "e $MYVIMRC",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Quit Neovim",
						desc_hl = "DashboardDesc",
						key = "q",
						key_hl = "DashboardKey",
						action = "qa",
					},
				},

				-- Disable project section to simplify the dashboard
				project = {
					enable = false,
				},

				-- Vertically center all content in the dashboard
				vertical_center = true,

				-- Empty footer
				footer = {},
			},
		})

		-- Set up dashboard colours
		vim.cmd([[
      highlight DashboardHeader guifg=#0fa9b8
      highlight DashboardIcon guifg=#00ffff
      highlight DashboardKey guifg=#00ffff
      highlight DashboardDesc guifg=#e0ffff
      highlight DashboardShortcut guifg=#0016f5
      highlight DashboardFooter guifg=#00b7eb
    ]])
	end,
}
