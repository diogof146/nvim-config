-- nvim-treesitter-endwise: Auto-add 'end', 'endif', 'done', etc.

return {
	"RRethy/nvim-treesitter-endwise",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},

	config = function()
		require("nvim-treesitter.configs").setup({
			endwise = {
				enable = true,
			},
		})
	end,
}
