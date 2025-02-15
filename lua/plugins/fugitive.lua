-- Git Integration for Neovim

return {
	"tpope/vim-fugitive",

	config = function()
		-- Define custom key mappings for common Git commands in normal mode

		-- Map <localleader>gs to :Git command (to check the status of the Git repository)
		vim.keymap.set("n", "<localleader>gs", ":Git<CR>", { noremap = true, silent = true })

    -- Map <localleader>ga to :Gwrite (to stage/add the current file)
    vim.keymap.set("n", "<localLeader>ga", ":Gwrite<CR>", { noremap = true, silent = true, desc = "Git add current file" })

		-- Map <localleader>gc to :Git commit command (to commit changes)
		vim.keymap.set("n", "<localleader>gc", ":Git commit<CR>", { noremap = true, silent = true })

		-- Map <localleader>gp to :Git push command (to push local changes to the remote repository)
		vim.keymap.set("n", "<localleader>gp", ":Git push<CR>", { noremap = true, silent = true })

		-- Map <localleader>gl to :Git pull command (to fetch and merge changes from the remote repository)
		vim.keymap.set("n", "<localleader>gl", ":Git pull<CR>", { noremap = true, silent = true })
	end,
}
