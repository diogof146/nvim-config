-- Statusline for Neovim

return {
	"nvim-lualine/lualine.nvim",

	config = function()
		-- Setup the 'lualine' plugin with the given configuration
		require("lualine").setup({
			options = {
				theme = "auto", -- Automatically choose a theme that matches your current colorscheme
			},
		})
	end,
}
