return {
	"mbbill/undotree",

	-- Lazy loading: Only load when specifically commanded
	cmd = "UndotreeToggle",

	-- Keys configuration
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
	},

	config = function()
		-- Set up undo directory
		local undo_dir = vim.fn.stdpath("data") .. "/undodir"
		vim.opt.undodir = undo_dir
		vim.opt.undofile = true

		-- Create directory if it doesn't exist
		if not vim.fn.isdirectory(undo_dir) then
			vim.fn.mkdir(undo_dir, "p")
		end

		-- Set undo limits
		vim.opt.undolevels = 1000

		-- Set up automated cleanup for macOS
		local cleanup_augroup = vim.api.nvim_create_augroup("UndoCleanup", { clear = true })
		vim.api.nvim_create_autocmd("VimEnter", {
			group = cleanup_augroup,
			callback = function()
				-- macOS-specific find command
				local cmd = string.format('/usr/bin/find "%s" -type f -mtime +90 -delete 2>/dev/null || true', undo_dir)
				vim.fn.jobstart(cmd)
			end,
		})

		-- Core configuration options for undotree
		vim.g.undotree_WindowLayout = 2
		vim.g.undotree_ShortIndicators = 1
		vim.g.undotree_SplitWidth = 30
		vim.g.undotree_SetFocusWhenToggle = 1

		-- Highlight configuration
		vim.cmd([[
            highlight! link UndotreeNode Special
            highlight! link UndotreeNodeCurrent Statement
            highlight! link UndotreeTimeStamp Number
            highlight! link UndotreeBranch Constant
        ]])
	end,
}
