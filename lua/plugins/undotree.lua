-- Undotree Plugin Configuration for Neovim

return {
	"mbbill/undotree",

	-- Lazy loading: Only load when specifically commanded
	cmd = "UndotreeToggle",

	-- Keys configuration for lazy.nvim
	-- This is a more explicit way to set up keymaps with lazy
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
	},

	-- Configuration is handled in the config function
	config = function()
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

	dependencies = {},
}
