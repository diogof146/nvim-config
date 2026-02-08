-- Advanced Substitute/Replace Operations

return {
	"gbprod/substitute.nvim",
	dependencies = { "y3owk1n/undo-glow.nvim" },
	event = "VeryLazy",
	opts = {
		-- Disable substitute's built-in highlights (undo-glow handles this)
		highlight_substituted_text = {
			enabled = false,
		},
		-- Yank substitute
		yank_substituted_text = false,
		-- Preserve cursor position
		preserve_cursor_position = false,
		-- Register for substitute operations
		on_substitute = nil,
		-- Range settings
		range = {
			prefix = "s",
			prompt_current_text = false,
			confirm = false,
			complete_word = false,
			subject = nil,
			range = nil,
			suffix = "",
		},
	},
	config = function(_, opts)
		require("substitute").setup(opts)

		-- Custom highlight for exchange visual selection
		vim.api.nvim_set_hl(0, "SubstituteExchange", { bg = "#317C85" })
	end,
	keys = {
		-- Substitute operator with customizable undo-glow highlight
		{
			"s",
			function()
				require("undo-glow").substitute_action(require("substitute").operator, {
					animation = {
						animation_type = "spring",
					},
					hl_color = { bg = "#317C85" },
				})
			end,
			mode = "n",
			desc = "Substitute with highlight",
		},
		-- Substitute line
		{
			"ss",
			function()
				require("undo-glow").substitute_action(require("substitute").line, {
					animation = {
						animation_type = "spring",
					},
					hl_color = { bg = "#317C85" },
				})
			end,
			mode = "n",
			desc = "Substitute line with highlight",
		},
		-- Substitute to end of line
		{
			"sS",
			function()
				require("undo-glow").substitute_action(require("substitute").eol, {
					animation = {
						animation_type = "spring",
					},
					hl_color = { bg = "#317C85" },
				})
			end,
			mode = "n",
			desc = "Substitute to end of line",
		},
		-- Visual mode substitute
		{
			"s",
			function()
				require("undo-glow").substitute_action(require("substitute").visual, {
					animation = {
						animation_type = "spring",
					},
					hl_color = { bg = "#317C85" },
				})
			end,
			mode = "x",
			desc = "Substitute selection",
		},
		-- Exchange operator (swap two regions)
		{
			"sx",
			function()
				require("substitute.exchange").operator()
			end,
			mode = "n",
			desc = "Exchange operator",
		},
		{
			"sxx",
			function()
				require("substitute.exchange").line()
			end,
			mode = "n",
			desc = "Exchange line",
		},
		{
			"X",
			function()
				require("substitute.exchange").visual()
			end,
			mode = "x",
			desc = "Exchange visual",
		},
		-- Cancel exchange
		{
			"sxc",
			function()
				require("substitute.exchange").cancel()
			end,
			mode = "n",
			desc = "Cancel exchange",
		},
	},
}
