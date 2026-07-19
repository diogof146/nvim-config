-- Git Integration - Inline Blame and Diff

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({

			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},

			-- Disable signs by default (controlled by toggle)
			signcolumn = false,

			-- Disabled by default (controlled by toggle)
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- Show at end of line
				delay = 500, -- Show after 500ms
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Track state per buffer
				if vim.b[bufnr].gitsigns_enabled == nil then
					vim.b[bufnr].gitsigns_enabled = false
				end

				map("n", "<leader>gt", function()
					vim.b[bufnr].gitsigns_enabled = not vim.b[bufnr].gitsigns_enabled

					if vim.b[bufnr].gitsigns_enabled then
						-- Enable all git features
						gs.toggle_signs(true)
						gs.toggle_current_line_blame(true)
						vim.notify("Git signs and blame enabled", vim.log.levels.INFO)
					else
						-- Disable all git features
						gs.toggle_signs(false)
						gs.toggle_current_line_blame(false)
						vim.notify("Git signs and blame disabled", vim.log.levels.INFO)
					end
				end, "Toggle git signs and blame")

				map("n", "<localleader>gb", gs.toggle_current_line_blame, "Toggle git blame only")
				map("n", "<localleader>gs", gs.toggle_signs, "Toggle git signs only")

				map("n", "<localleader>gd", gs.diffthis, "Git diff this file")
				map("n", "<localleader>gp", gs.preview_hunk, "Preview git hunk")

				map("n", "<localleader>jh", gs.next_hunk, "Next git hunk")
				map("n", "<localleader>kh", gs.prev_hunk, "Previous git hunk")

				map("n", "<localleader>hs", gs.stage_hunk, "Stage current hunk")
				map("n", "<localleader>hr", gs.reset_hunk, "Reset current hunk")
			end,
		})
	end,
}
