-- Neovim Commenting Plugin Configuration

return {
	"numToStr/Comment.nvim", -- The plugin repository (GitHub: numToStr/Comment.nvim)

	config = function()
		-- Load and configure the Comment.nvim plugin
		require("Comment").setup({
			-- Sticky Comments:
			-- When enabled, the cursor remains on the same line after commenting/uncommenting.
			sticky = true,

			-- Key Mappings Configuration:
			mappings = {
				-- Basic Mappings:
				-- `gcc`: Toggles a comment for the current line
				-- `gbc`: Toggles a block comment for the current selection or block
				basic = true,

				-- Extra Mappings:
				-- `gco`: Adds a comment on the line below the cursor
				-- `gcO`: Adds a comment on the line above the cursor
				-- `gcA`: Adds a comment at the end of the current line
				extra = true,
			},
		})
	end,
}
