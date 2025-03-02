return {
	"rachartier/tiny-glimmer.nvim",
	event = "VeryLazy",
	config = function()
		require("tiny-glimmer").setup({
			-- Master switch for the whole plugin
			enabled = true,
			-- Default animation style when none is specified
			default_animation = "fade",
			-- Animation refresh rate in milliseconds (lower = smoother but more CPU intensive)
			refresh_interval_ms = 6,
			-- Configuration for different operations that trigger animations
			overwrite = {
				-- Use plugin's default key mappings when true
				auto_map = true,
        -- Search operation settings
        search = {
            enabled = false,
            default_animation = "bounce",
            next_mapping = 'nzzzv', 
            prev_mapping = 'Nzzzv', 
        },
				-- Paste operation settings
				paste = {
					enabled = true,
					default_animation = "fade",
					paste_mapping = "p", -- Paste after cursor
					Paste_mapping = "P", -- Paste before cursor
				},
				-- Undo operation settings
				undo = {
					enabled = true,
					default_animation = "fade",
					undo_mapping = "u",
				},
				-- Redo operation settings
				redo = {
					enabled = true,
					default_animation = "fade",
					redo_mapping = "U",
				},
			},
			-- Animation definitions
			animations = {
				fade = {
					max_duration = 500, -- Maximum animation duration in milliseconds
					min_duration = 400, -- Minimum animation duration in milliseconds
					easing = "outQuad", -- Animation progression curve
					chars_for_max_duration = 10, -- Text length threshold for max duration
				},
			},
			-- Virtual text display settings
			virt_text = {
				priority = 2048,
			},
			-- Transparency color setting
			transparency_color = "#000000",
		})
	end,
}
