return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			vim.keymap.set("n", "<leader>ct", "<cmd>ColorizerToggle<cr>", { desc = "Toggle Colors" }),
		})
	end,
}
