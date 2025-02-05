return {
	"rachartier/tiny-glimmer.nvim",
	event = "VeryLazy", -- Load the plugin lazily after Neovim starts up
	config = function()
		require("tiny-glimmer").setup({
			-- Master switch for the whole plugin
			enabled = true,

			-- The default animation style used when one isn't specified
			default_animation = "fade",

			-- How often (in milliseconds) the animation refreshes
			-- Lower = smoother but more CPU intensive
			refresh_interval_ms = 6,

			-- Configuration for different operations that trigger animations
			overwrite = {
				-- When true, uses the plugin's default key mappings
				-- Set to false if you want to manually define triggers
				auto_map = true,

				-- Settings for paste operations
				paste = {
					enabled = true,
					default_animation = "fade", -- Changed from reverse_fade to match yank style
					paste_mapping = "p", -- Trigger on lowercase p (paste after cursor)
					Paste_mapping = "P", -- Trigger on uppercase P (paste before cursor)
				},
			},

			-- Animation definitions
			animations = {
				fade = {
					-- Maximum duration of the animation in milliseconds
					max_duration = 300,

					-- Minimum duration of the animation in milliseconds
					min_duration = 200,

					-- The easing function determines how the animation progresses
					-- 'outQuad' means it starts fast and slows down at the end
					easing = "outQuad",

					-- This value helps scale the animation duration based on text length
					-- If the text is longer than this many characters, it will use max_duration
					-- If shorter, it scales between min and max duration
					chars_for_max_duration = 10,
				},
			},

			-- Settings for the virtual text that shows the animation
			virt_text = {
				-- Higher priority means it will show above other virtual text
				priority = 2048,
			},
		})
	end,
}
