return {
	"echasnovski/mini.icons",
	opts = {
		-- 'glyph' uses Nerd Font icons, 'ascii' uses text fallbacks
		style = "glyph",

		-- You can also define custom icons for specific filetypes here
		-- filetype = {
		--   java = { glyph = '', hl = 'MiniIconsAzure' },
		-- },
	},
	lazy = false,
	specs = {
		{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
	},
	init = function()
		-- This mocks the old plugin so your other plugins don't crash
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
