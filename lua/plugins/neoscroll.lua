return {
	"karb94/neoscroll.nvim",
	config = function()
		require("neoscroll").setup({
			mappings = {
				"<C-u>", -- Cursor moves UP half-page, view follows cursor
				"<C-d>", -- Cursor moves DOWN half-page, view follows cursor
				"<C-b>", -- Cursor moves UP full-page, view follows cursor
				"<C-f>", -- Cursor moves DOWN full-page, view follows cursor
				"<C-y>", -- View scrolls UP one line, cursor stays in same screen position
				"<C-e>", -- View scrolls DOWN one line, cursor stays in same screen position
				"zt", -- Move current line (where cursor is) to TOP of screen
				"zz", -- Move current line (where cursor is) to CENTER of screen
				"zb", -- Move current line (where cursor is) to BOTTOM of screen
			},
			hide_cursor = true, -- Hide cursor while scrolling
			stop_eof = true, -- Stop at <EOF> when scrolling downwards
			respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
			cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
			duration_multiplier = 1.0, -- Global duration multiplier
			easing = "linear", -- Default easing function
			pre_hook = nil, -- Function to run before the scrolling animation starts
			post_hook = nil, -- Function to run after the scrolling animation ends
			performance_mode = false, -- Disable 'Performance Mode' on all buffers.
			ignored_events = { -- Events ignored while scrolling
				"WinScrolled",
				"CursorMoved",
			},
		})

		-- Manually mapping Ctrl+j/k to scroll half-page up/down
		vim.keymap.set({ "n", "v", "x" }, "<C-j>", function()
			require("neoscroll").scroll(vim.wo.scroll, { move_cursor = true, duration = 100 })
		end)
		vim.keymap.set({ "n", "v", "x" }, "<C-k>", function()
			require("neoscroll").scroll(-vim.wo.scroll, { move_cursor = true, duration = 100 })
		end)
	end,
}
