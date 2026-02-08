-- Visual Undo/Redo Highlights

return {
	"y3owk1n/undo-glow.nvim",
	event = { "VeryLazy" },
	---@type UndoGlow.Config
	opts = {
		animation = {
			enabled = true,
			duration = 300,
			animation_type = "desaturate", -- Default for most actions
			window_scoped = true,
		},
		highlights = {
			undo = {
				hl_color = { bg = "#317C85" },
			},
			redo = {
				hl_color = { bg = "#317C85" },
			},
			yank = {
				hl_color = { bg = "#317C85" },
			},
			paste = {
				hl_color = { bg = "#317C85" },
			},
			search = {
				hl_color = { bg = "#317C85" },
			},
			comment = {
				hl_color = { bg = "#317C85" },
			},
			cursor = {
				hl_color = { bg = "#317C85" },
			},
		},
		priority = 2048 * 3,
	},
	keys = {
		-- Undo
		{
			"u",
			function()
				require("undo-glow").undo({
					animation = {
						animation_type = "blink",
					},
				})
			end,
			mode = "n",
			desc = "Undo with highlight",
			noremap = true,
		},
		-- Redo
		{
			"<C-r>",
			function()
				require("undo-glow").redo({
					animation = {
						animation_type = "blink",
					},
				})
			end,
			mode = "n",
			desc = "Redo with highlight",
			noremap = true,
		},
		-- Paste
		{
			"p",
			function()
				require("undo-glow").paste_below({
					animation = {
						animation_type = "spring",
					},
				})
			end,
			mode = "n",
			desc = "Paste below with highlight",
			noremap = true,
		},
		-- Paste
		{
			"P",
			function()
				require("undo-glow").paste_above({
					animation = {
						animation_type = "spring",
					},
				})
			end,
			mode = "n",
			desc = "Paste above with highlight",
			noremap = true,
		},
		-- Search
		{
			"n",
			function()
				require("undo-glow").search_next({
					animation = {
						animation_type = "jitter",
					},
				})
			end,
			mode = "n",
			desc = "Search next with highlight",
			noremap = true,
		},
		{
			"N",
			function()
				require("undo-glow").search_prev({
					animation = {
						animation_type = "jitter",
					},
				})
			end,
			mode = "n",
			desc = "Search prev with highlight",
			noremap = true,
		},
		{
			"*",
			function()
				require("undo-glow").search_star({
					animation = {
						animation_type = "jitter",
					},
				})
			end,
			mode = "n",
			desc = "Search star with highlight",
			noremap = true,
		},
		{
			"#",
			function()
				require("undo-glow").search_hash({
					animation = {
						animation_type = "jitter",
					},
				})
			end,
			mode = "n",
			desc = "Search hash with highlight",
			noremap = true,
		},
		-- Comment with fade animation
		{
			"gc",
			function()
				-- Preserve cursor position
				local pos = vim.fn.getpos(".")
				vim.schedule(function()
					vim.fn.setpos(".", pos)
				end)
				return require("undo-glow").comment({
					animation = {
						animation_type = "desaturate",
					},
				})
			end,
			mode = { "n", "x" },
			desc = "Toggle comment with highlight",
			expr = true,
			noremap = true,
		},
		{
			"gc",
			function()
				require("undo-glow").comment_textobject({
					animation = {
						animation_type = "desaturate",
					},
				})
			end,
			mode = "o",
			desc = "Comment textobject with highlight",
			noremap = true,
		},
		{
			"gcc",
			function()
				return require("undo-glow").comment_line({
					animation = {
						animation_type = "desaturate",
					},
				})
			end,
			mode = "n",
			desc = "Toggle comment line with highlight",
			expr = true,
			noremap = true,
		},
	},
	init = function()
		-- Yank highlighting
		vim.api.nvim_create_autocmd("TextYankPost", {
			desc = "Highlight when yanking (copying) text",
			callback = function()
				require("undo-glow").yank({
					animation = {
						animation_type = "pulse",
					},
				})
			end,
		})

		-- Cursor movement highlighting
		vim.api.nvim_create_autocmd("CursorMoved", {
			desc = "Highlight when cursor moved significantly",
			callback = function()
				require("undo-glow").cursor_moved({
					animation = {
						animation_type = "slide",
					},
				})
			end,
		})

		-- Focus gained highlighting
		vim.api.nvim_create_autocmd("FocusGained", {
			desc = "Highlight when focus gained",
			callback = function()
				local opts = {
					animation = {
						animation_type = "slide",
					},
				}

				opts = require("undo-glow.utils").merge_command_opts("UgCursor", opts)
				local pos = require("undo-glow.utils").get_current_cursor_row()

				require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
					s_row = pos.s_row,
					s_col = pos.s_col,
					e_row = pos.e_row,
					e_col = pos.e_col,
					force_edge = opts.force_edge == nil and true or opts.force_edge,
				}))
			end,
		})

		-- Search command highlighting
		vim.api.nvim_create_autocmd("CmdlineLeave", {
			desc = "Highlight when search cmdline leave",
			callback = function()
				require("undo-glow").search_cmd({
					animation = {
						animation_type = "jitter",
					},
				})
			end,
		})
	end,
}

--[[
Available animation types:
- "fade" - Smooth fade out (default)
- "pulse" - Breathing effect
- "zoom" - Brief brightness increase
- "slide" - Moves right before fading
- "blink" - Rapid on/off toggle
- "strobe" - Rapid color changes
- "jitter" - Shaky/vibrating effect
- "spring" - Overshoots then settles
- "rainbow" - Cycles through colors
- "desaturate" - Gradually mutes colors
- "fade_reverse" - Smooth fade in
--]]
