-- Neovimm Leap plugin configuration

return {
	"ggandor/leap.nvim",
	dependencies = {
		"tpope/vim-repeat",
	},
	config = function()
		vim.keymap.set({ "n", "x" }, "f", "<Plug>(leap)")
		vim.keymap.set("n", "F", "<Plug>(leap-from-window)")

    -- The following are commented because I'm not currently using them but
    -- they'd be useful for a bigger change at instant leaps

		-- vim.keymap.set("o", "<leader>s", "<Plug>(leap-forward)")
		-- vim.keymap.set("o", "<leader>S", "<Plug>(leap-backward)")

	end,
}
