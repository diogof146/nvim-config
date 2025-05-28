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



-- Key Mappings Configuration

-- Define the "leader key" as space
-- The leader key is a customizable prefix key for user-defined shortcuts
vim.g.mapleader = " " -- Global leader key
vim.g.maplocalleader = "," -- Local leader key

-- Key mappings for indentation in visual mode
-- "<Tab>": Indents the selected text and keeps the selection active
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true }) -- Indent
-- "<S-Tab>": Unindents the selected text and keeps the selection active
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true }) -- Unindent

-- Swapping redo with undo-line for convenience
-- U: Redoes changes
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo", noremap = true })
-- C-r: Undoes changes in a single line
vim.keymap.set("n", "<C-r>", "U", { desc = "Undo line changes", noremap = true })

-- Swap the functionality of 'b' and 'q' keys in normal mode
-- 'b': Normally moves backward by one word, now used for recording macros
vim.keymap.set("n", "b", "q", { noremap = true })
-- 'q': Normally starts recording macros, now moves backward by one word
vim.keymap.set("n", "q", "b", { noremap = true })

-- Remap gg and G to include start/end of line movements
vim.keymap.set("n", "gg", "gg0", { noremap = true, desc = "Go to first line and start" })
vim.keymap.set("n", "G", "G$", { noremap = true, desc = "Go to last line and end" })

-- Map <Leader>db to open the dashboard
vim.keymap.set("n", "<Leader>db", ":Dashboard<CR>", { noremap = true, silent = true })
-- Map <Leader>b to go to the previous buffer (:bp)
vim.keymap.set("n", "<Leader>b", ":bp<CR>", { noremap = true, silent = true })


-- Mapping global word replacement with confirmation
vim.keymap.set('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>//gc<left><left><left>', { noremap = true })

-- Make delete operations not affect the clipboard
-- The "void register" (_) is used to discard deleted text
vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true, desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { noremap = true, desc = "Delete to end without yanking" })
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true, desc = "Delete character without yanking" })
vim.keymap.set("n", "S", '"_cc', { noremap = true, desc = "Substitute line without yanking" })
vim.keymap.set("n", "C", '"_C', { noremap = true, desc = "Change to end without yanking" })
vim.keymap.set("n", "s", '"_s', { noremap = true, desc = "Substitute character without yanking" })


-- Disabling comment auto insert
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove("o")
    end
})


-- Core Editor Settings

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




-- Plugin Initialization with Lazy.nvim
require("lazy").setup("plugins")
