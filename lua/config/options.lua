-- Core Editor Settings

-- Define the "leader key" as space
-- The leader key is a customizable prefix key for user-defined shortcuts
vim.g.mapleader = " " -- Global leader key
vim.g.maplocalleader = "," -- Local leader key

-- Define editor options in a table for better organization
local options = {
	-- Display Configuration
	number = true, -- Enable line numbers for the active buffer
	relativenumber = true, -- Enable relative line numbers (useful for motions)
	cursorline = true, -- Highlight the current line for better focus
	splitright = true, -- New vertical splits open to the right of the current window
	splitbelow = true, -- New horizontal splits open below the current window

	-- Text Editing Configuration
	expandtab = true, -- Convert tabs into spaces
	shiftwidth = 2, -- Number of spaces used for indentation
	tabstop = 2, -- Number of spaces for a tab character

	-- System Integration
	clipboard = "unnamedplus", -- Use the system clipboard for copy/paste
	mouse = "a", -- Enable mouse support in all modes

	-- File Management
	backup = false, -- Disable creation of backup files
	writebackup = false, -- Disable backup files during editing
	swapfile = true, -- Enable creation of swap files for crash recovery
	directory = vim.fn.expand("~/.local/share/nvim/swap//"), -- Set swap file directory
}

-- Apply the editor options defined above
for k, v in pairs(options) do
	vim.opt[k] = v -- Set each option using vim.opt
end
