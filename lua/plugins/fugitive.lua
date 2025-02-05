-- Git Integration for Neovim

return {
	"tpope/vim-fugitive",

	config = function()
		-- Define custom key mappings for common Git commands in normal mode

		-- Map <leader>gs to :Git command (to check the status of the Git repository)
		vim.keymap.set("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true })

		-- Map <leader>gc to :Git commit command (to commit changes)
		vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true })

		-- Map <leader>gp to :Git push command (to push local changes to the remote repository)
		vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true })

		-- Map <leader>gl to :Git pull command (to fetch and merge changes from the remote repository)
		vim.keymap.set("n", "<leader>gl", ":Git pull<CR>", { noremap = true, silent = true })
	end,
}
