-- nvim-treesitter-context: Show function/class context at top of screen
-- When scrolling in a long function, shows the function signature at top

return {
	"nvim-treesitter/nvim-treesitter-context",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},

	config = function()
		require("treesitter-context").setup({
			enable = true,
			max_lines = 3, -- Max lines to show
			min_window_height = 20, -- Minimum editor height to enable
			line_numbers = true,
			multiline_threshold = 1, -- Max lines for single context
			trim_scope = "outer", -- Remove outer whitespace
			mode = "cursor", -- Show context of cursor position
			separator = nil, -- No separator line
		})

		-- Toggle context visibility
		vim.keymap.set("n", "<leader>tc", function()
			require("treesitter-context").toggle()
		end, { desc = "Toggle Treesitter Context" })
	end,
}
