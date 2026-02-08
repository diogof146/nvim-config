-- Git Integration - Inline Blame and Diff
return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			-- Git change signs in the gutter
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},

			-- Enable sign column
			signcolumn = true,

			-- Inline git blame (who edited this line)
			current_line_blame = false, -- Off by default, toggle with <localleader>tb
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- Show at end of line
				delay = 500, -- Show after 500ms
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

			-- Simple keybinds
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Toggle inline blame (who edited each line)
				map("n", "<localleader>gb", gs.toggle_current_line_blame, "Toggle git blame")

				-- Show diff of current file (side-by-side)
				map("n", "<localleader>gd", gs.diffthis, "Git diff this file")

				-- Preview hunk (shows what changed in a popup)
				map("n", "<localleader>gp", gs.preview_hunk, "Preview git hunk")

				-- Navigate between changes
				map("n", "<localleader>jh", gs.next_hunk, "Next git hunk")
				map("n", "<localleader>kh", gs.prev_hunk, "Previous git hunk")

				-- Stage the specific block you are standing on
				map("n", "<localleader>hs", gs.stage_hunk, "Stage current hunk")

				-- Undo (Reset) the specific block you are standing on
				map("n", "<localleader>hr", gs.reset_hunk, "Reset current hunk")

				-- Toggle all git signs (hides everything)
				map("n", "<leader>gt", gs.toggle_signs, "Toggle git signs")
			end,
		})
	end,
}
