-- init.lua: Neovim Configuration - Core Setup and Package Manager Initialization

-- Package Manager Setup (Lazy.nvim)
-- Determine the installation path for Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if Lazy.nvim is already installed
if vim.fn.empty(vim.fn.glob(lazypath)) > 0 then
	-- Clone Lazy.nvim repository if it is not installed

	vim.fn.system({
		"git",
		"clone", -- Git command to clone repositories
		"--filter=blob:none", -- Clone without file history (lightweight clone)
		"https://github.com/folke/lazy.nvim.git", -- Repository URL for Lazy.nvim
		"--branch=stable", -- Use the stable branch for better reliability
		lazypath, -- Target installation path
	})
end

-- Add Lazy.nvim to the runtime path, making it available for Neovim to use
vim.opt.rtp:prepend(lazypath)

-- Load core configuration
require("config.options") -- Editor settings
require("config.keymaps") -- General keybindings
require("config.autocmds") -- Autocommands and QOL features

-- Plugin Initialization with Lazy.nvim
require("lazy").setup("plugins", {
	change_detection = { enabled = false },
	checker = { enabled = false },
})
