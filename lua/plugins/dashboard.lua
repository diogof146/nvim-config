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
				
				-- COMMENTED BLACK BACKGROUND SETTINGS (uncomment if needed for theme changes)
				-- vim.cmd([[highlight DashboardNormal guibg=#000000 ctermbg=0]])
				-- vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
			end,
		})

		-- Fix cursor visibility when staying in the dashboard
		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
			pattern = "*",
			callback = function()
				if vim.bo.filetype == "dashboard" then
					vim.opt_local.guicursor = "a:block-Cursor/lCursor-blinkon0"
					vim.cmd([[highlight Cursor blend=100]])
					
					-- COMMENTED BLACK BACKGROUND
					-- vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })

				else
					vim.opt.guicursor = original_guicursor
					vim.cmd([[highlight Cursor blend=0]])
					
					-- COMMENTED BACKGROUND RESTORATION
					-- vim.api.nvim_set_hl(0, "Normal", { bg = nil })
				end

			end,
		})

		-- Only restore settings when actually loading a real file, not just when leaving dashboard temporarily
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
					
					-- COMMENTED BACKGROUND RESTORATION
					-- vim.api.nvim_set_hl(0, "Normal", { bg = nil })

				end

				-- COMMENTED DASHBOARD BLACK BACKGROUND ENFORCEMENT
				-- if filetype == "dashboard" then
				--     vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
				-- end

			end,
		})

		db.setup({
			theme = "doom", -- Use the "doom" theme
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
					"",
					"",
          "",
				},

				-- Disable week header for better performance
				week_header = {
					enable = false,
				},

				-- Main shortcut actions for the dashboard
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
						desc = "New File",
						desc_hl = "DashboardDesc",
						key = "n",
						key_hl = "DashboardKey",
						action = "enew",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Bookmarks",
						desc_hl = "DashboardDesc",
						key = "b",
						key_hl = "DashboardKey",
						action = "Telescope marks",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Plugin Manager",
						desc_hl = "DashboardDesc",
						key = "l",
						key_hl = "DashboardKey",
						action = "Lazy",
					},
					{
					    icon = " ",
					    icon_hl = "DashboardIcon",
					    desc = "Projects",
					    desc_hl = "DashboardDesc",
					    key = "p",
					    key_hl = "DashboardKey",
					    action = "Telescope projects",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Help Tags",
						desc_hl = "DashboardDesc",
						key = "h",
						key_hl = "DashboardKey",
						action = "Telescope help_tags",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Terminal",
						desc_hl = "DashboardDesc",
						key = "t",
						key_hl = "DashboardKey",
						action = "terminal",
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

				-- Disable project section to keep dashboard clean and fast
				project = {
					enable = false,
				},

				-- Vertically center all content in the dashboard
				vertical_center = true,

				-- Empty footer for clean appearance
				footer = {},
			},
		})

		-- Set up dashboard color scheme
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
