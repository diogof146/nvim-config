-- Neovimm Leap plugin configuration

return {
	"ggandor/leap.nvim",
	dependencies = {
		"tpope/vim-repeat",
	},
	config = function()
		vim.keymap.set({ "n", "x" }, "f", "<Plug>(leap)")
		vim.keymap.set("n", "F", "<Plug>(leap-from-window)")

		vim.keymap.set("o", "<leader>s", "<Plug>(leap-forward)")
		vim.keymap.set("o", "<leader>S", "<Plug>(leap-backward)")
	end,
}
