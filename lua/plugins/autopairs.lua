-- Autocompletion plugin for Neovim

return {
	"windwp/nvim-autopairs",

	config = function()
		-- Setup the 'nvim-autopairs' plugin with the default configuration
		require("nvim-autopairs").setup({})
	end,
}
