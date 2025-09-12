return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("notify").setup({
			background_colour = "#000000",
			render = "default",
			timeout = 3000,
			level = vim.log.levels.INFO,
			minimum_width = 50,
			maximum_width = 0.75,
			icons = {
				ERROR = "",
				WARN = "",
				INFO = "",
				DEBUG = "",
				TRACE = "✎",
			},
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,

			fps = 30,
			top_down = true,
		})

		-- Set nvim-notify as the default notify function
		vim.notify = require("notify")

		require("noice").setup({
			routes = {
				-- Skip search_count messages entirely
				{
					filter = { event = "msg_show", kind = { "search_count" } },
					opts = { skip = true },
				},
				-- Route error messages to notify
				{
					filter = { event = "msg_show", kind = { "emsg", "echo", "echomsg" } },
					view = "notify",
				},
				-- Route warning messages to notify
				{
					filter = { event = "msg_show", kind = { "wmsg" } },
					view = "notify",
				},
				-- Route long messages to split view
				{
					filter = { event = "msg_show", min_height = 20 },
					view = "split",
				},
			},
			views = {
				notify = {
					replace = true, -- Replace old notifications to prevent duplicates
				},
			},
			lsp = {
				progress = { enabled = false },
				message = { enabled = false },
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = false,
			},
			-- Disable noice's own notification handling to prevent duplicates
			notify = {
				enabled = false, -- Let nvim-notify handle notifications directly
			},
			messages = {
				enabled = true,
				view = "notify", -- Route messages through noice to notify
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = false, -- Disable search messages in noice
			},
		})
	end,
}
