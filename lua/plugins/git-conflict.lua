return {
	"akinsho/git-conflict.nvim",
	version = "*",
	config = function()
		require("git-conflict").setup({
			default_mappings = {
				ours = "co",
				theirs = "ct",
				none = "cn",
				both = "cb",
				next = "n",
				prev = "N",
			},
		})
	end,
}
